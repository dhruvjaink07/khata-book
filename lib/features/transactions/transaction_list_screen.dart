import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata/features/transactions/service/transaction_service.dart';
import 'package:khata/features/transactions/widgets/category_filter_chip.dart';
import 'package:khata/features/transactions/widgets/search_field.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:khata/services/app_service.dart';

import 'domain/transaction.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  AppService appService = AppService();
  TransactionService transactionService = TransactionService();
  Box<Transaction> box = Hive.box<Transaction>('transactions');
  String? selectedFilter;
  final List<Transaction> transactions = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Use localization keys for filters
  List<String> getCommonFilters(AppLocalizations loc) => [
    loc.filterAll,
    loc.filterThisMonth,
    loc.filterGroceries,
    loc.filterShopping,
    loc.filterSalary,
    loc.filterRent,
    loc.filterTravel,
    loc.filterOthers,
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    transactions.clear();
    final allTransactions = box.values.toList();

    // Sort by date descending (most recent first)
    allTransactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (selectedFilter == null || selectedFilter == "All") {
      transactions.addAll(allTransactions);
    } else if (selectedFilter == "This Month") {
      final now = DateTime.now();
      transactions.addAll(
        allTransactions.where(
          (txn) =>
              txn.dateTime.year == now.year && txn.dateTime.month == now.month,
        ),
      );
    } else {
      // Map localized filter back to category key if needed
      transactions.addAll(
        allTransactions.where(
          (txn) =>
              appService.getCategoryLabel(
                AppLocalizations.of(context)!,
                txn.category,
              ) ==
              selectedFilter,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final commonFilters = getCommonFilters(loc);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.transaction,
          style: TextStyle(
            fontStyle: GoogleFonts.inter().fontStyle,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Transaction> box, _) {
          List<Transaction> txns = box.values.toList();
          txns.sort((a, b) => b.dateTime.compareTo(a.dateTime));

          // Use the service for filtering and grouping
          final filteredTxns = transactionService
              .filterTransactions(
                txns,
                selectedFilter,
                loc,
                appService.getCategoryLabel,
              )
              .where((txn) {
                if (_searchQuery.isEmpty) return true;
                final query = _searchQuery.toLowerCase();
                return txn.notes?.toLowerCase().contains(query) == true ||
                    appService
                        .getCategoryLabel(loc, txn.category)
                        .toLowerCase()
                        .contains(query) ||
                    txn.amount.toString().contains(query);
              })
              .toList();
          final grouped = transactionService.groupTransactions(
            filteredTxns,
            loc,
          );

          return Column(
            children: [
              SearchField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              CategoryFilterChips(
                filters: commonFilters,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = selected;
                  });
                },
              ),
              Expanded(
                child: grouped.isEmpty
                    ? Center(child: Text(loc.noTransactionsFound))
                    : ListView(
                        children: grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ...entry.value.map(
                                (txn) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(
                                      txn.isIncome
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: txn.isIncome
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  title: Text(
                                    appService.getCategoryLabel(
                                      loc,
                                      txn.category,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      txn.notes != null && txn.notes!.isNotEmpty
                                      ? Text(txn.notes!)
                                      : null,
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${txn.isIncome ? '+' : '-'}₹${txn.amount.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: txn.isIncome
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(txn.dateTime),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
