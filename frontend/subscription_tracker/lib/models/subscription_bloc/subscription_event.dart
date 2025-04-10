import 'package:subscription_tracker/models/subscription_model.dart';

abstract class SubscriptionEvent {}

class AddSubscriptionEvent extends SubscriptionEvent {
  final SubscriptionModel subscription;

  AddSubscriptionEvent(this.subscription);
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
  final SubscriptionModel subscription;

  DeleteSubscriptionEvent(this.subscription);
}
