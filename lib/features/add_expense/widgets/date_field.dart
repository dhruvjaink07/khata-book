import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  const DateField({super.key, required this.onDateSelected});

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      widget.onDateSelected(picked); // passing to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      readOnly: true,
      onTap: () => _selectDate(context),
      controller: TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(selectedDate),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? colorScheme.surfaceVariant : Color(0xFFF1F1F1),
        suffixIcon: Icon(
          Icons.calendar_today_outlined,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: colorScheme.onSurface),
    );
  }
}
