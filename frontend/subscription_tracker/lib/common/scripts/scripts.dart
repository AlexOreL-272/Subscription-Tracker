abstract class CustomDateFormat {
  // ignore: non_constant_identifier_names
  static CustomDateFormat MMMMyyyy({required bool isRussian}) {
    return isRussian
        ? RussianDateFormat.MMMMyyyy()
        : EnglishDateFormat.MMMMyyyy();
  }

  static CustomDateFormat ddMMMMyyyy({required bool isRussian}) {
    return isRussian
        ? RussianDateFormat.ddMMMMyyyy()
        : EnglishDateFormat.ddMMMMyyyy();
  }

  // ignore: non_constant_identifier_names
  static CustomDateFormat MMM({required bool isRussian}) {
    return isRussian ? RussianDateFormat.MMM() : EnglishDateFormat.MMM();
  }

  String format(DateTime date);
}

class RussianDateFormat implements CustomDateFormat {
  static const monthNamesNominativ = <String>[
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];

  static const monthNamesGenitiv = <String>[
    'Января',
    'Февраля',
    'Марта',
    'Апреля',
    'Мая',
    'Июня',
    'Июля',
    'Августа',
    'Сентября',
    'Октября',
    'Ноября',
    'Декабря',
  ];

  static const monthNamesShort = <String>[
    'Янв',
    'Фев',
    'Мар',
    'Апр',
    'Май',
    'Июн',
    'Июл',
    'Авг',
    'Сен',
    'Окт',
    'Ноя',
    'Дек',
  ];

  final bool _includeDay;
  final bool _includeYear;
  final bool _isShortMonth;

  // ignore: non_constant_identifier_names
  const RussianDateFormat.MMMMyyyy()
    : _includeDay = false,
      _includeYear = true,
      _isShortMonth = false;

  const RussianDateFormat.ddMMMMyyyy()
    : _includeDay = true,
      _includeYear = true,
      _isShortMonth = false;

  // ignore: non_constant_identifier_names
  const RussianDateFormat.MMM()
    : _includeDay = false,
      _includeYear = false,
      _isShortMonth = true;

  @override
  String format(DateTime date) {
    final month =
        _isShortMonth
            ? monthNamesShort[date.month - 1]
            : _includeDay
            ? monthNamesGenitiv[date.month - 1]
            : monthNamesNominativ[date.month - 1];

    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');

    if (_includeDay) {
      return '$day $month $year';
    } else if (_includeYear) {
      return '$month $year';
    } else {
      return month;
    }
  }
}

class EnglishDateFormat implements CustomDateFormat {
  static const monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const monthNamesShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final bool _includeDay;
  final bool _includeYear;
  final bool _isShortMonth;

  // ignore: non_constant_identifier_names
  const EnglishDateFormat.MMMMyyyy()
    : _includeDay = false,
      _includeYear = true,
      _isShortMonth = false;

  const EnglishDateFormat.ddMMMMyyyy()
    : _includeDay = true,
      _includeYear = true,
      _isShortMonth = false;

  // ignore: non_constant_identifier_names
  const EnglishDateFormat.MMM()
    : _includeDay = false,
      _includeYear = false,
      _isShortMonth = true;

  @override
  String format(DateTime date) {
    final month =
        _isShortMonth
            ? monthNamesShort[date.month - 1]
            : monthNames[date.month - 1];

    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');

    if (_includeDay) {
      return '$day $month $year';
    } else if (_includeYear) {
      return '$month $year';
    } else {
      return month;
    }
  }
}
