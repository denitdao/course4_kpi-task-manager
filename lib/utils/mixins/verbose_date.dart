import 'package:intl/intl.dart';

abstract class VerboseDate {
  String getVerboseDateTime(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('d/MM/y').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Today';
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

    if (localDateTime.isAfter(now) &&
        localDateTime.difference(now).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return weekday;
    }

    return formattedDate;
  }
}
