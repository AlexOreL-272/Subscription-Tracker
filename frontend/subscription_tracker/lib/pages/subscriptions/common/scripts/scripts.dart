import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final extractedDate = DateTime.parse(date.toString().split(' ')[0]);
  final format = DateFormat('dd.MM.yyyy');

  return format.format(extractedDate);
}

String getInitials(String caption) {
  final words = caption.split(' ');

  if (words.length == 1) {
    return words[0][0].toUpperCase();
  }

  return '${words[0][0].toUpperCase()}${words[1][0].toUpperCase()}';
}

// assuming that interval is in days (stated in my API :) )
// and is either a predefined value like N day(s), N week(s), N month(s) or N year(s)
// or a custom value in days
String formatCost(double cost, String currency, int interval) {
  final formattedInterval = formatPreviewPeriod(interval);
  return '${cost.toStringAsFixed(2)} $currency / $formattedInterval';
}

String formatPreviewPeriod(int interval, [bool conjugate = true]) {
  String formattedInterval;

  // looks terrific...
  if (interval % 30 != 0 && interval % 365 != 0) {
    if (interval % 10 == 1 && interval % 100 != 11) {
      formattedInterval = '$interval День';
    } else if (interval == 7) {
      formattedInterval = conjugate ? '1 Неделю' : '1 Неделя';
    } else if (interval % 7 == 0 && interval < 30) {
      formattedInterval = '${interval ~/ 7} Недели';
    } else if (interval % 10 >= 2 &&
        interval % 10 <= 4 &&
        interval % 100 != 12 &&
        interval % 100 != 13 &&
        interval % 100 != 14) {
      formattedInterval = '$interval Дня';
    } else {
      formattedInterval = '$interval Дней';
    }
  } else if (interval < 365) {
    interval ~/= 30;

    if (interval == 1) {
      formattedInterval = '1 Месяц';
    } else if (interval >= 2 && interval <= 4) {
      formattedInterval = '$interval Месяца';
    } else {
      formattedInterval = '$interval Месяцев';
    }
  } else {
    interval ~/= 365;

    if (interval == 1) {
      formattedInterval = '1 Год';
    } else if (interval >= 2 && interval <= 4) {
      formattedInterval = '$interval Года';
    } else {
      formattedInterval = '$interval Лет';
    }
  }

  return formattedInterval;
}

double getTextWidth(String text, [TextStyle? style]) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: ui.TextDirection.ltr,
  )..layout();

  return textPainter.width;
}

Color darkenColor(Color color, double amount) {
  final hsv = HSVColor.fromColor(color);
  return hsv.withValue(hsv.value * (1 - amount)).toColor();
}
