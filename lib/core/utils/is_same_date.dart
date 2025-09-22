bool isSameDay(DateTime? firstDate, DateTime? secondDate) {
  if (firstDate == null || secondDate == null) {
    return false;
  }
  return firstDate.year == secondDate.year &&
    firstDate.month == secondDate.month &&
    firstDate.day == secondDate.day;
}