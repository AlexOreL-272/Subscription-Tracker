int countCharges({
  required DateTime start,
  required DateTime end,
  required DateTime firstPay,
  required int intervalDays,
  required DateTime cutoff,
}) {
  int count = 0;
  DateTime current = firstPay;

  while (!current.isAfter(cutoff)) {
    if (!current.isBefore(start) && !current.isAfter(end)) {
      count++;
    }
    current = current.add(Duration(days: intervalDays));
  }

  return count;
}
