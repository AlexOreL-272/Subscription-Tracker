import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/repo/category_repo/category_repo.dart';
import 'package:subscription_tracker/repo/subscriptions_repo/subscriptions_repo.dart';
import 'package:subscription_tracker/repo/user_repo/user_repo.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionsRepo subsRepo;
  final CategoryRepo categoryRepo;
  final UserRepo userRepo;

  SubscriptionBloc({
    required this.subsRepo,
    required this.categoryRepo,
    required this.userRepo,
  }) : super(SubscriptionState.sample()) {
    on<InitializeSubscriptionsEvent>(_initializeSubscriptions);
    on<AddSubscriptionEvent>(_addSubscription);
    on<FetchSubscriptionsEvent>(_fetchSubscriptions);
    on<SaveSubscriptionsEvent>(_saveSubscriptions);
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
    await subsRepo.put(
      event.subscription,
      userRepo.user.authStatus == AuthStatus.authorized,
      userRepo.user.id,
    );

    emit(SubscriptionState(subsRepo.subscriptions));
  }

  Future<void> _fetchSubscriptions(
    FetchSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final start = DateTime.now();

    while (userRepo.user.authStatus != AuthStatus.authorized) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (DateTime.now().difference(start).inSeconds >= 5) {
        emit(SubscriptionState(subsRepo.subscriptions));
        return;
      }
    }

    final newSubs = await subsRepo.fetchSubscriptions(
      userId: userRepo.user.id!,
      accessToken: userRepo.user.accessToken!,
    );

    emit(SubscriptionState(subsRepo.subscriptions));

    for (final newSub in newSubs) {
      if (categoryRepo.categories.contains(newSub.category) ||
          newSub.category == 'Все' ||
          newSub.category == '' ||
          newSub.category == null) {
        continue;
      }

      categoryRepo.put(newSub.category!);
    }
  }

  Future<void> _saveSubscriptions(
    SaveSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final start = DateTime.now();

    while (userRepo.user.authStatus != AuthStatus.authorized) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (DateTime.now().difference(start).inSeconds >= 5) {
        emit(SubscriptionState(subsRepo.subscriptions));
        return;
      }
    }

    await subsRepo.saveSubscriptions(userRepo.user.id!);
    emit(SubscriptionState(subsRepo.subscriptions));
  }

  Future<void> _updateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    await subsRepo.update(
      event.subscription,
      userRepo.user.authStatus == AuthStatus.authorized,
    );

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
    await subsRepo.delete(
      event.id,
      userRepo.user.authStatus == AuthStatus.authorized,
    );

    emit(SubscriptionState(subsRepo.subscriptions));
  }

  @override
  Future<void> close() async {
    await subsRepo.close();
    return super.close();
  }
}
