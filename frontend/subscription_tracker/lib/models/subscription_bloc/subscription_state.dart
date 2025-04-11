import 'package:subscription_tracker/models/subscription_model.dart';

class SubscriptionState {
  final Map<String, SubscriptionModel> subscriptions;

  const SubscriptionState(this.subscriptions);

  SubscriptionState.sample()
    : this({
        "asd": SubscriptionModel(
          id: "asd",

          caption: "My Test Subscription",
          comment: "Test comment",

          cost: 123.45,
          currency: 'RUB',

          firstPay: DateTime.now(),
          interval: 30,
          endDate: DateTime(2026, 01, 20),
          notification: 30,

          color: 0xFF2196F3,
          category: null,

          isActive: true,

          trialActive: false,
          trialInterval: 30,
          trialCost: 0.10,
          trialEndDate: DateTime(2026, 01, 20),
          trialNotification: 30,

          supportLink: 'youtube.com',
          supportPhone: '+7 (999) 999-99-99',
        ),

        "ase": SubscriptionModel(
          id: "ase",

          caption: "Second Test Subscription",
          comment: "Second Test comment",

          cost: 321.45,
          currency: 'KZT',

          firstPay: DateTime.now(),
          interval: 30,
          endDate: DateTime(2026, 01, 20),
          notification: 30,

          color: 0xFFFF5722,
          category: 'Android',

          isActive: true,

          trialActive: false,
          trialInterval: 30,
          trialCost: 0.10,
          trialEndDate: DateTime(2026, 01, 20),
          trialNotification: 30,

          supportLink: 'example.com',
          supportPhone: '+7 (999) 888-99-99',
        ),

        "asf": SubscriptionModel(
          id: "asf",

          caption: "Third Test Subscription",
          comment: "Third Test comment",

          cost: 888.1,
          currency: 'USD',

          firstPay: DateTime.now(),
          interval: 30,
          endDate: DateTime(2026, 01, 20),
          notification: 30,

          color: 0xFFFFEB3B,
          category: 'iOS',

          isActive: true,

          trialActive: false,
          trialInterval: 30,
          trialCost: 0.10,
          trialEndDate: DateTime(2026, 01, 20),
          trialNotification: 30,

          supportLink: 'google.com',
          supportPhone: '+7 (999) 777-99-99',
        ),

        "asg": SubscriptionModel(
          id: "asg",

          caption:
              "Четвертая подписка (надо посмотреть как выглядит длинный текст (ну очень длинный текст))",
          comment: "Third Test comment",

          cost: 1375.1,
          currency: 'RUB',

          firstPay: DateTime(2025, 03, 20),
          interval: 14,
          endDate: DateTime(2025, 08, 13),
          notification: 30,

          color: 0xFF4CAF50,
          category: 'Flutter',

          isActive: true,

          trialActive: false,
          trialInterval: 30,
          trialCost: 0.10,
          trialEndDate: DateTime(2026, 01, 20),
          trialNotification: 30,

          supportLink: 'youtube.com',
          supportPhone: '+7 (999) 777-99-99',
        ),

        "ash": SubscriptionModel(
          id: "ash",

          caption: "Пятая подписочка",
          comment: "Fifth Test comment",

          cost: 2268.46,
          currency: 'USD',

          firstPay: DateTime(2025, 04, 17),
          interval: 14,
          endDate: DateTime(2026, 04, 13),
          notification: 30,

          color: 0xFF6750A4,
          category: null,

          isActive: true,

          trialActive: false,
          trialInterval: 30,
          trialCost: 0.10,
          trialEndDate: DateTime(2026, 01, 20),
          trialNotification: 30,

          supportLink: 'facebook.com',
          supportPhone: '+7 (999) 777-99-99',
        ),
      });
}
