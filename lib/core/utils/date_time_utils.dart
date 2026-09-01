import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'log.greeting_morning';
    } else if (hour >= 12 && hour < 17) {
      return 'log.greeting_afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'log.greeting_evening';
    } else {
      return 'log.greeting_night';
    }
  }

  static String formatHeaderDate(DateTime dt) {
    return DateFormat('d MMMM yyyy').format(dt);
  }

  static String formatLogTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  static String formatLogDateGroup(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(dt.year, dt.month, dt.day);

    if (checkDate == today) {
      return 'Today · ${DateFormat('d MMMM').format(dt)}';
    } else if (checkDate == yesterday) {
      return 'Yesterday · ${DateFormat('d MMMM').format(dt)}';
    } else {
      return DateFormat('EEEE, d MMMM yyyy').format(dt);
    }
  }

  static String formatExportDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }
}
