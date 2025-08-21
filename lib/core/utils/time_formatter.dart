import 'package:intl/intl.dart';

/// Utility class for formatting time and duration values
class TimeFormatter {
  TimeFormatter._();

  /// Format a DateTime to a time string (HH:mm)
  static String formatTime(DateTime dateTime, {bool use24Hour = true}) {
    if (use24Hour) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('h:mm a').format(dateTime);
    }
  }

  /// Format a DateTime to a date string
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  /// Format a DateTime to a full date and time string
  static String formatDateTime(DateTime dateTime, {bool use24Hour = true}) {
    final timeStr = formatTime(dateTime, use24Hour: use24Hour);
    final dateStr = formatDate(dateTime);
    return '$dateStr at $timeStr';
  }

  /// Format a Duration to a readable string (e.g., "1h 23m", "45m", "2h")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${hours}h';
      }
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '${seconds}s';
    }
  }

  /// Format a Duration to a precise string with seconds (e.g., "1:23:45", "23:45", "0:45")
  static String formatDurationPrecise(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Format a Duration to timer display format (e.g., "01:23:45")
  static String formatDurationForTimer(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Convert minutes to duration string (e.g., "25 minutes", "1 hour 30 minutes")
  static String minutesToDurationString(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      if (remainingMinutes > 0) {
        return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''}';
      }
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  /// Get relative time string (e.g., "2 hours ago", "just now")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  /// Format total work time for the day
  static String formatDailyTotal(Duration totalTime) {
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m total';
    } else {
      return '${minutes}m total';
    }
  }

  /// Format time range (e.g., "9:00 AM - 5:30 PM")
  static String formatTimeRange(DateTime start, DateTime end, {bool use24Hour = true}) {
    final startTime = formatTime(start, use24Hour: use24Hour);
    final endTime = formatTime(end, use24Hour: use24Hour);
    return '$startTime - $endTime';
  }

  /// Check if a time is within business hours
  static bool isWithinBusinessHours(DateTime dateTime) {
    final hour = dateTime.hour;
    return hour >= 9 && hour < 17; // 9 AM to 5 PM
  }

  /// Get work day progress as percentage (0.0 to 1.0)
  static double getWorkDayProgress(Duration workedTime, Duration targetTime) {
    if (targetTime.inMilliseconds == 0) return 0.0;
    final progress = workedTime.inMilliseconds / targetTime.inMilliseconds;
    return progress.clamp(0.0, 1.0);
  }
}