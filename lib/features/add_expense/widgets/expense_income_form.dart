import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khata/features/add_expense/widgets/submit_button.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'package:khata/services/app_service.dart';

import 'date_field.dart';
import 'input_widget.dart';

class ExpenseIncomeForm extends StatefulWidget {
  final List<String> categories;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final bool isExpense;
  final VoidCallback? onSubmit;
  final String? selectedCategory;
  final ValueChanged<String?>? onCategoryChanged;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?>? onDateChanged;

  const ExpenseIncomeForm({
    super.key,
    required this.categories,
    required this.amountController,
    required this.notesController,
    required this.isExpense,
    required this.onSubmit,
    this.selectedCategory,
    this.onCategoryChanged,
    this.selectedDate,
    this.onDateChanged,
  });

  @override
  _ExpenseIncomeForm createState() => _ExpenseIncomeForm();
}

class _ExpenseIncomeForm extends State<ExpenseIncomeForm> {
  AppService appService = AppService();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount
          Text(
            loc.amount,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InputWidget(
            amountController: widget.amountController,
            hintText: '0.00',
            prefixText: '₹ ',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 15),

          // Category
          Text(
            loc.category,
            style: TextStyle(
              fontStyle: GoogleFonts.inter().fontStyle,
              color: isDarkMode ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: widget.selectedCategory,
            hint: Text(loc.category),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDarkMode
                  ? theme.colorScheme.surface
                  : const Color(0xFFF1F1F1),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            items: widget.categories.map((categoryKey) {
              return DropdownMenuItem(
                value: categoryKey,
                child: Text(appService.getCategoryLabel(loc, categoryKey)),
              );
            }).toList(),
            onChanged: (value) {
              if (widget.onCategoryChanged != null) {
                widget.onCategoryChanged!(value);
              }
            },
          ),
          const SizedBox(height: 15),

          // Date
          Text(
            loc.dateLabel,
            style: TextStyle(
              fontStyle: GoogleFonts.inter().fontStyle,
              color: isDarkMode ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          DateField(
            onDateSelected: (date) {
              if (widget.onDateChanged != null) {
                widget.onDateChanged!(date);
              }
            },
          ),
          const SizedBox(height: 15),

          // Notes
          Text(
            loc.notesLabel,
            style: TextStyle(fontStyle: GoogleFonts.inter().fontStyle),
          ),
          const SizedBox(height: 10),
          InputWidget(
            amountController: widget.notesController,
            hintText: loc.notesHint,
            maxLines: 3,
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 50),

          // Submit Button
          SubmitButton(
            onpressed: () {
              if (widget.onSubmit != null) {
                widget.onSubmit!();
              }
            },
          ),
        ],
      ),
    );
  }
}
