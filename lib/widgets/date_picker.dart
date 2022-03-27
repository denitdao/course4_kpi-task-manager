import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FormDatePicker extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;

  const FormDatePicker({
    Key? key,
    required this.date,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: date == null
          ? const Text('Choose the date')
          : Text(intl.DateFormat.yMd().format(date!)),
      onPressed: () async {
        var now = DateTime.now();
        var newDate = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(now.year, now.month - 1, now.day),
          lastDate: DateTime(now.year + 1, now.month, now.day),
        );

        // Don't change the date if the date picker returns null.
        if (newDate == null || newDate == date) {
          return;
        }

        onChanged(newDate);
      },
    );
  }
}
