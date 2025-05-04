import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/repo/subscriptions_repo/subscriptions_repo.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionsRepo subsRepo;

  SubscriptionBloc({required this.subsRepo})
    : super(SubscriptionState.sample()) {
    on<InitializeSubscriptionsEvent>(_initializeSubscriptions);
    on<AddSubscriptionEvent>(_addSubscription);
    on<UpdateSubscriptionEvent>(_updateSubscription);
    on<ResetCategoriesEvent>(_resetCategories);
    on<DeleteSubscriptionEvent>(_deleteSubscription);

    add(InitializeSubscriptionsEvent());
  }

  Future<void> _initializeSubscriptions(
    InitializeSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionState(subsRepo.subscriptions));
  }

  Future<void> _addSubscription(
    AddSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await subsRepo.put(event.subscription);
    emit(SubscriptionState(subsRepo.subscriptions));
  }

  Future<void> _updateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await subsRepo.update(event.subscription);
    emit(SubscriptionState(subsRepo.subscriptions));
  }

  Future<void> _resetCategories(
    ResetCategoriesEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await subsRepo.updateCategories(event.oldCategory, event.newCategory);
    emit(SubscriptionState(subsRepo.subscriptions));
  }

  Future<void> _deleteSubscription(
    DeleteSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await subsRepo.delete(event.id);
    emit(SubscriptionState(subsRepo.subscriptions));
  }

  @override
  Future<void> close() async {
    await subsRepo.close();
    return super.close();
  }
}
