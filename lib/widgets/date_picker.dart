import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FormDateRangePicker extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  final Function onChanged;

  const FormDateRangePicker({
    Key? key,
    required this.start,
    required this.end,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: start == null && end == null
          ? const Text('Choose the date')
          : Text(intl.DateFormat('EEEE d/MM/y').format(start!) +
              '  -  ' +
              intl.DateFormat('EEEE d/MM/y').format(end!)),
      onPressed: () async {
        DateTimeRange? initial = (start != null && end != null)
            ? DateTimeRange(start: start!, end: end!)
            : null;
        var now = DateTime.now();
        DateTimeRange? newDate = await showDateRangePicker(
          context: context,
          initialDateRange: initial,
          firstDate: DateTime(now.year, now.month - 2, now.day),
          lastDate: DateTime(now.year + 1, now.month, now.day),
        );

        // Don't change the date if the date picker returns null.
        if (newDate == null || (newDate.start == start && newDate.end == end)) {
          return;
        }

        onChanged(newDate.start, newDate.end);
      },
    );
  }
}
