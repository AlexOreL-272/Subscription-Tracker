import 'package:subscription_tracker/models/subscription_model.dart';

class SharedData {
  static final SharedData _instance = SharedData._();

  SharedData._();

  static SharedData get instance => _instance;

  static const List<String> currencies = ['RUB', 'USD', 'EUR', 'UAH', 'KZT'];
  static const Map<String, int> intervals = {
    '1 День': 1,
    '1 Неделя': 7,
    '2 Недели': 14,
    '1 Месяц': 30,
    '3 Месяца': 90,
    '6 Месяцев': 180,
    '1 Год': 365,
    'Выбрать': 0,
  };

  List<SubscriptionModel> subscriptions = [
    SubscriptionModel(
      id: "asd",
      caption: "My Test Subscription",
      cost: 123.45,
      currency: 'RUB',
      firstPay: DateTime.now(),
      interval: 30,
      color: 0xFFFF0000,
    ),
  ];

  List<String> categories = ['Все'];
}
