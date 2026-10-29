/// Small date helpers (named DateUtilsX to avoid clashing with Flutter's DateUtils).
class DateUtilsX {
  DateUtilsX._();

  static const _months = [
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
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// "21 Oct 2026"
  static String format(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// "October 2026" style header.
  static String monthTitle(DateTime d) =>
      '${_monthLong[d.month - 1]} ${d.year}';

  static String weekday(DateTime d) => _weekdays[d.weekday - 1];

  /// "Today", "Yesterday" or the formatted date.
  static String relative(DateTime d, {DateTime? now}) {
    final today = dateOnly(now ?? DateTime.now());
    final diff = today.difference(dateOnly(d)).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return format(d);
  }

  static const _monthLong = [
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
}
