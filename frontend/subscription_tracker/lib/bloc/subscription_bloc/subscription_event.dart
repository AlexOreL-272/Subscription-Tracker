import 'package:subscription_tracker/models/subscription_model.dart';

abstract class SubscriptionEvent {}

class AddSubscriptionEvent extends SubscriptionEvent {
  final SubscriptionModel subscription;

  AddSubscriptionEvent(this.subscription);
}

class FetchSubscriptionsEvent extends SubscriptionEvent {
  final String userId;
  final String accessToken;
  final int? limit;
  final int? offset;

  FetchSubscriptionsEvent(
    this.userId,
    this.accessToken, [
    this.limit = 1000,
    this.offset = 0,
  ]);
}

class UpdateSubscriptionEvent extends SubscriptionEvent {
  final SubscriptionModel subscription;

  UpdateSubscriptionEvent(this.subscription);
}

class ResetCategoriesEvent extends SubscriptionEvent {
  final String oldCategory;
  final String? newCategory;

  ResetCategoriesEvent(this.oldCategory, this.newCategory);
}

class DeleteSubscriptionEvent extends SubscriptionEvent {
  final String id;

  DeleteSubscriptionEvent(this.id);
}

class InitializeSubscriptionsEvent extends SubscriptionEvent {}
