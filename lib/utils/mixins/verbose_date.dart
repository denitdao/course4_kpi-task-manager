import 'package:intl/intl.dart';

abstract class VerboseDate {
  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime tomorrow = now.subtract(const Duration(days: -1));

    if (localDateTime.day == tomorrow.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Tomorrow';
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (-4 < now.difference(localDateTime).inDays &&
        now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return '$weekday';
      // return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}';
    // return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
