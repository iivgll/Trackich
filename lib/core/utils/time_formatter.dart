import 'package:intl/intl.dart';

class TimeFormatter {
  static String formatDuration(Duration duration, {bool showSeconds = true}) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (showSeconds) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}';
    }
  }

  static String formatTime(DateTime dateTime, {bool is24Hour = true}) {
    if (is24Hour) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('h:mm a').format(dateTime);
    }
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  static String formatDateShort(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime, {bool is24Hour = true}) {
    final date = formatDate(dateTime);
    final time = formatTime(dateTime, is24Hour: is24Hour);
    return '$date at $time';
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDurationWords(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '0m';
    }
  }

  static String formatProgressPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  static String formatHours(double hours) {
    if (hours < 1) {
      final minutes = (hours * 60).round();
      return '${minutes}m';
    } else if (hours == hours.toInt()) {
      return '${hours.toInt()}h';
    } else {
      return '${hours.toStringAsFixed(1)}h';
    }
  }

  static Duration parseDurationFromHours(double hours) {
    return Duration(milliseconds: (hours * 60 * 60 * 1000).round());
  }

  static double durationToHours(Duration duration) {
    return duration.inMilliseconds / (1000 * 60 * 60);
  }

  static String formatWeekRange(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    if (startOfWeek.month == endOfWeek.month) {
      return '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('d, yyyy').format(endOfWeek)}';
    } else {
      return '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, yyyy').format(endOfWeek)}';
    }
  }

  static DateTime getStartOfWeek(DateTime date, {bool mondayFirst = true}) {
    final weekday = date.weekday;
    final daysToSubtract = mondayFirst ? weekday - 1 : weekday % 7;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysToSubtract));
  }

  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static String formatTimeAgo(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    } else if (isYesterday(dateTime)) {
      return 'Yesterday';
    } else {
      return formatRelativeTime(dateTime);
    }
  }

  /// Format month and year for calendar headers
  static String formatMonthYear(DateTime dateTime) {
    return DateFormat('MMMM y').format(dateTime);
  }

  /// Format day of week (e.g., "Monday")
  static String formatDayOfWeek(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }
}
