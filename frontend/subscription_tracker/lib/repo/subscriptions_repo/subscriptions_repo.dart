import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscription_tracker/domain/subscriptions/requests.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class SubscriptionsRepo {
  static final _platform = MethodChannel(
    'com.example.subscription_tracker/update_widget',
  );
  static const _boxName = 'subscriptionsBox';

  late final Box<Map> _box;

  static const _compactionThreshold = 10;
  int _saveOperations = 0;

  late final Map<String, SubscriptionModel> _subscriptions;

  final SubsApiService apiService;

  SubscriptionsRepo({required this.apiService});

  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);

    _subscriptions = _box.toMap().map((key, value) {
      final stringKey = key.toString();
      final jsonValue = Map<String, dynamic>.from(value);

      return MapEntry(stringKey, SubscriptionModel.fromJson(jsonValue));
    });

    _adjustSubscriptionFirstPay();

    await _updateAndroidWidget();
  }

  Future<List<SubscriptionModel>> fetchSubscriptions({
    required String userId,
    required String accessToken,
    int limit = 1000,
    int offset = 0,
  }) async {
    final response = await apiService.getSubscriptions(
      userId: userId,
      resultType: 'full',
      limit: limit,
      offset: offset,
    );

    if (!response.isSuccessful) {
      if (response.statusCode == 404) {
        return [];
      }

      // TODO: handle expired access token
      return [];
    }

    final newSubs = <SubscriptionModel>[];

    for (final subscription in response.body!) {
      if (_subscriptions.containsKey(subscription.id)) {
        continue;
      }

      _subscriptions[subscription.id] = subscription;
      newSubs.add(subscription);
      _box.put(subscription.id, subscription.toJson());
    }

    _adjustSubscriptionFirstPay();

    return newSubs;
  }

  Future<void> saveSubscriptions(String userId) async {
    for (final subscription in _subscriptions.values) {
      await apiService.createSubscription(
        request: CreateSubscriptionRequest(
          userId: userId,
          subscription: subscription,
        ),
      );
    }
  }

  Future<void> close() async {
    await _box.compact();
    await _box.close();
  }

  Future<void> put(
    SubscriptionModel subscription, [
    bool needsSync = false,
    String? userId,
  ]) async {
    await _box.put(subscription.id, subscription.toJson());

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    if (needsSync) {
      apiService.createSubscription(
        request: CreateSubscriptionRequest(
          userId: userId!,
          subscription: subscription,
        ),
      );
    }

    _subscriptions[subscription.id] = subscription;

    await _updateAndroidWidget();
  }

  Future<void> update(
    SubscriptionModel subscription, [
    bool needsSync = false,
  ]) async {
    await _box.put(subscription.id, subscription.toJson());

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    if (needsSync) {
      apiService.updateSubscription(
        subscriptionId: subscription.id,
        subscription: subscription,
      );
    }

    _subscriptions[subscription.id] = subscription;

    await _updateAndroidWidget();
  }

  Future<void> delete(String id, [bool needsSync = false]) async {
    await _box.delete(id);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    if (needsSync) {
      apiService.deleteSubscription(subscriptionId: id);
    }

    _subscriptions.remove(id);

    await _updateAndroidWidget();
  }

  Future<void> updateCategories(String oldCategory, String? newCategory) async {
    for (final entry in _subscriptions.entries) {
      if (entry.value.category != oldCategory) {
        continue;
      }

      _subscriptions[entry.key] = entry.value.copyWith(category: newCategory);
      await _box.put(entry.key, entry.value.toJson());
    }

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  Map<String, SubscriptionModel> get subscriptions => _subscriptions;

  void _adjustSubscriptionFirstPay() {
    final subs = _subscriptions.values.toList();

    for (final subscription in subs) {
      if (subscription.firstPay.isAfter(DateTime.now())) {
        continue;
      }

      DateTime firstPay = subscription.firstPay;

      while (firstPay.isBefore(DateTime.now())) {
        firstPay = firstPay.add(Duration(days: subscription.interval));
      }

      _subscriptions[subscription.id] = subscription.copyWith(
        firstPay: firstPay,
      );
    }
  }

  String _getSubscriptionsString() {
    final subscriptions = _subscriptions.values.toList();
    subscriptions.sort((a, b) => a.firstPay.compareTo(b.firstPay));

    return jsonEncode(
      subscriptions
          .map(
            (subscription) => _SubscriptionWidgetData(
              caption: subscription.caption,
              cost: subscription.cost,
              currency: subscription.currency,
              firstPay: subscription.firstPay,
            ),
          )
          .toList(),
    );
  }

  Future<void> _updateAndroidWidget() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('subscriptions', _getSubscriptionsString());

      // Then notify the platform to update the widget
      await _platform.invokeMethod('updateWidget');
    } catch (e) {
      debugPrint('Error updating widget: $e');
    }
  }
}

class _SubscriptionWidgetData {
  final String caption;
  final double cost;
  final String currency;
  final DateTime firstPay;

  const _SubscriptionWidgetData({
    required this.caption,
    required this.cost,
    required this.currency,
    required this.firstPay,
  });

  Map<String, dynamic> toJson() => {
    'caption': caption,
    'cost': cost,
    'currency': currency,
    'firstPay': firstPay.toIso8601String(),
  };
}
