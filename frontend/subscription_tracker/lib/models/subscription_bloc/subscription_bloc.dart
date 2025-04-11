import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/models/subscription_model.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  static const _boxName = 'subscriptionsBox';

  late final Box<Map> _box;

  static const _compactionThreshold = 10;
  int _saveOperations = 0;

  SubscriptionBloc() : super(SubscriptionState.sample()) {
    on<InitializeSubscriptionsEvent>(_initialize);

    on<AddSubscriptionEvent>(_addSubscription);
    on<UpdateSubscriptionEvent>(_updateSubscription);
    on<ResetCategoriesEvent>(_resetCategories);
    on<DeleteSubscriptionEvent>(_deleteSubscription);

    add(InitializeSubscriptionsEvent());
  }

  Future<void> _initialize(
    InitializeSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    _box = await Hive.openBox<Map>(_boxName);
    final subscriptions = _box.toMap().map((key, value) {
      final stringKey = key.toString();
      final jsonValue = Map<String, dynamic>.from(value);

      return MapEntry(stringKey, SubscriptionModel.fromJson(jsonValue));
    });

    for (final entry in state.subscriptions.entries) {
      await _box.put(entry.key, entry.value.toJson());
    }

    emit(SubscriptionState(subscriptions));
  }

  Future<void> _addSubscription(
    AddSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await _box.put(event.subscription.id, event.subscription.toJson());

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(
      SubscriptionState({
        ...state.subscriptions,
        event.subscription.id: event.subscription,
      }),
    );
  }

  Future<void> _updateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await _box.put(event.subscription.id, event.subscription.toJson());

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(
      SubscriptionState({
        ...state.subscriptions,
        event.subscription.id: event.subscription,
      }),
    );
  }

  Future<void> _resetCategories(
    ResetCategoriesEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final updatedSubs = <String, SubscriptionModel>{};
    for (final entry in state.subscriptions.entries) {
      if (entry.value.category == event.oldCategory) {
        updatedSubs[entry.key] = entry.value.copyWith(
          category: event.newCategory,
        );
      } else {
        updatedSubs[entry.key] = entry.value;
      }
    }

    for (final entry in updatedSubs.entries) {
      await _box.put(entry.key, entry.value.toJson());
    }

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(SubscriptionState(updatedSubs));
  }

  Future<void> _deleteSubscription(
    DeleteSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await _box.delete(event.id);
    final newSubs = Map<String, SubscriptionModel>.from(state.subscriptions)
      ..remove(event.id);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(SubscriptionState(newSubs));
    _box.compact();
  }

  @override
  Future<void> close() {
    _box.compact();
    _box.close();
    return super.close();
  }
}
