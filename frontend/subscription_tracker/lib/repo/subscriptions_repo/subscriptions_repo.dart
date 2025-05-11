import 'package:hive/hive.dart';
import 'package:subscription_tracker/domain/subscriptions/requests.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class SubscriptionsRepo {
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
}
