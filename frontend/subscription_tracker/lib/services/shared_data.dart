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
      comment: "Test comment",

      cost: 123.45,
      currency: 'RUB',

      firstPay: DateTime.now(),
      interval: 30,
      endDate: DateTime(2026, 01, 20),
      notification: 30,

      color: 0xFFFF0000,
      category: 'Music',

      isActive: true,

      trialActive: true,
      trialInterval: 30,
      trialCost: 0.10,
      trialEndDate: DateTime(2026, 01, 20),
      trialNotification: 30,

      supportLink: 'youtube.com',
      supportPhone: '+7 (999) 999-99-99',
    ),
  ];

  List<String> categories = ['Все'];
}
