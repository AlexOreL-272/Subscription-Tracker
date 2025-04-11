class SharedData {
  static final SharedData _instance = SharedData._();

  SharedData._();

  static SharedData get instance => _instance;

  static const List<String> currencies = ['RUB', 'USD', 'EUR', 'UAH', 'KZT'];

  static const selectCustomValue = 'Выбрать';
  static const Map<String, int> intervals = {
    '1 День': 1,
    '1 Неделя': 7,
    '2 Недели': 14,
    '1 Месяц': 30,
    '3 Месяца': 90,
    '6 Месяцев': 180,
    '1 Год': 365,
    selectCustomValue: 0,
  };
}
