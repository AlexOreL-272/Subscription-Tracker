class SharedData {
  static final SharedData _instance = SharedData._();

  SharedData._();

  static SharedData get instance => _instance;

  static const String devEmail = 'shevchuk.aa@phystech.edu';

  static const List<String> currencies = [
    'BYN',
    'RUB',
    'UAH',
    'KZT',
    'USD',
    'EUR',
  ];
  static const Map<String, String> currenciesSymbols = {
    'BYN': 'Br',
    'RUB': '₽',
    'UAH': '₴',
    'KZT': '₸',
    'USD': '\$',
    'EUR': '€',
  };
  static const List<String> currenciesDescriptions = [
    'Белорусский рубль',
    'Российский рубль',
    'Украинская гривна',
    'Казахский тенге',
    'Доллар США',
    'Евро',
  ];

  static const selectCustomValueRU = 'Выбрать';
  static const Map<String, int> intervalsRU = {
    '1 День': 1,
    '1 Неделя': 7,
    '2 Недели': 14,
    '1 Месяц': 30,
    '3 Месяца': 90,
    '6 Месяцев': 180,
    '1 Год': 365,
    selectCustomValueRU: 0,
  };

  static const selectCustomValueEN = 'Select';
  static const Map<String, int> intervalsEN = {
    '1 Day': 1,
    '1 Week': 7,
    '2 Weeks': 14,
    '1 Month': 30,
    '3 Months': 90,
    '6 Months': 180,
    '1 Year': 365,
    selectCustomValueEN: 0,
  };
}
