import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/models/subscription_model.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionState.zero()) {
    on<AddSubscriptionEvent>((event, emit) {
      final newSubs = Map<String, SubscriptionModel>.from(state.subscriptions)
        ..addEntries([MapEntry(event.subscription.id, event.subscription)]);

      emit(SubscriptionState(newSubs));
    });

    on<UpdateSubscriptionEvent>((event, emit) {
      final newSubs = Map<String, SubscriptionModel>.from(state.subscriptions)
        ..[event.subscription.id] = event.subscription;

      emit(SubscriptionState(newSubs));
    });

    on<ResetCategoriesEvent>((event, emit) {
      final newSubs = Map<String, SubscriptionModel>.from(state.subscriptions)
        ..updateAll((key, value) {
          if (value.category != event.oldCategory) {
            return value;
          }

          return value.copyWith(category: event.newCategory);
        });

      emit(SubscriptionState(newSubs));
    });

    on<DeleteSubscriptionEvent>((event, emit) {
      final newSubs = Map<String, SubscriptionModel>.from(state.subscriptions)
        ..removeWhere((key, value) => key == event.subscription.id);

      emit(SubscriptionState(newSubs));
    });
  }
}
