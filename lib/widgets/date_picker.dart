import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        intl.DateFormat.yMd().format(widget.date),
        // style: Theme.of(context).textTheme.subtitle1,
      ),
      onPressed: () async {
        var now = DateTime.now();
        var newDate = await showDatePicker(
          context: context,
          initialDate: widget.date,
          firstDate: DateTime(now.year, now.month - 1, now.day),
          lastDate: DateTime(now.year + 1, now.month, now.day),
        );

        // Don't change the date if the date picker returns null.
        if (newDate == null) {
          return;
        }

        widget.onChanged(newDate);
      },
    );
  }
}
