import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.amountController,
    required this.hintText,
    this.maxLines = 1,
    this.prefixText = '',
    required this.keyboardType,
  });
  final TextEditingController amountController;
  final int? maxLines;
  final String prefixText;
  final String hintText;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: amountController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.7),
          fontSize: 18,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.4),
          fontSize: 18,
        ),
        filled: true,
        fillColor: isDark ? colorScheme.surfaceVariant : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
    );
  }
}
