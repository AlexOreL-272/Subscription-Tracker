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

class DeleteSubscriptionEvent extends SubscriptionEvent {
  final SubscriptionModel subscription;

  DeleteSubscriptionEvent(this.subscription);
}
