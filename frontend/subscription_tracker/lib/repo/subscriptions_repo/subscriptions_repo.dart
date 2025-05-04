import 'package:hive/hive.dart';
import 'package:subscription_tracker/models/subscription_model.dart';

class SubscriptionsRepo {
  static const _boxName = 'subscriptionsBox';

  late final Box<Map> _box;

  static const _compactionThreshold = 10;
  int _saveOperations = 0;

  late final Map<String, SubscriptionModel> _subscriptions;

  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);

    _subscriptions = _box.toMap().map((key, value) {
      final stringKey = key.toString();
      final jsonValue = Map<String, dynamic>.from(value);

      return MapEntry(stringKey, SubscriptionModel.fromJson(jsonValue));
    });
  }

  Future<void> close() async {
    await _box.compact();
    await _box.close();
  }

  Future<void> put(SubscriptionModel subscription) async {
    await _box.put(subscription.id, subscription.toJson());

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    _subscriptions[subscription.id] = subscription;
  }

  Future<void> update(SubscriptionModel subscription) async {
    await _box.put(subscription.id, subscription.toJson());

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    _subscriptions[subscription.id] = subscription;
  }

  Future<void> delete(String id) async {
    await _box.delete(id);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
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
