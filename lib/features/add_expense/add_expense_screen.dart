import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata/features/add_expense/services/add_expense_service.dart';
import 'package:khata/features/add_expense/widgets/expense_income_form.dart';
import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:khata/l10n/app_localizations.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  var box = Hive.box<Transaction>('transactions');

  // State variable to track if the transaction is an expense or income
  bool isExpense = true;

  String? selectedCategory;

  DateTime? selectedDate;

  AddExpenseService addExpenseService = AddExpenseService();

  final List<String> expenseCategories = [
    "foodAndDining",
    "groceries",
    "transport",
    "healthAndFitness",
    "shopping",
    "entertainment",
    "utilities",
    "rent",
    "travel",
    "education",
    "subscriptions",
    "insurance",
    "personalCare",
    "giftsAndDonations",
    "othersCategory",
  ];
  final List<String> incomeCategories = [
    "salary",
    "freelance",
    "interest",
    "investments",
    "gifts",
    "rentalIncome",
    "refunds",
    "otherIncome",
  ];

  Future<void> addTransaction() async {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a category')));
      return;
    }
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    Transaction transaction = Transaction(
      amount: double.parse(_amountController.text),
      title: selectedCategory!,
      category: selectedCategory!,
      dateTime: selectedDate ?? DateTime.now(),
      isIncome: !isExpense,
      notes: _notesController.text,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      currency: "INR",
    );
    await box.add(transaction);

    _amountController.clear();
    _notesController.clear();
    setState(() {
      selectedCategory = null;
      selectedDate = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Transaction added!')));
  }

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(loc.addTransaction),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Toggle Buttons for Expense / Income
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildToggleButton(loc.expense, isExpense, colorScheme),
                    _buildToggleButton(loc.income, !isExpense, colorScheme),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Content based on selection
              ExpenseIncomeForm(
                amountController: _amountController,
                categories: isExpense ? expenseCategories : incomeCategories,
                notesController: _notesController,
                isExpense: isExpense,
                onSubmit: addTransaction,
                selectedCategory: selectedCategory,
                onCategoryChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                selectedDate: selectedDate,
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isActive,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpense = label == AppLocalizations.of(context)!.expense;
            selectedCategory = null;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Color(0xff0066FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
