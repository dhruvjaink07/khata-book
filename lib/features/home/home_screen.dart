import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata/features/home/service/home_service.dart';
import 'package:khata/features/home/widgets/chart_analytics.dart';
import 'package:khata/features/home/widgets/summary_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'package:khata/services/app_service.dart';
import '../../widgets/transaction_card.dart';
import '../transactions/domain/transaction.dart';
import 'package:khata/features/add_expense/services/add_expense_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Transaction> box;
  AppService appService = AppService();
  HomeService homeService = HomeService();
  final addExpenseService = AddExpenseService();

  @override
  void initState() {
    super.initState();
    box = Hive.box<Transaction>('transactions');
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final loc = AppLocalizations.of(context)!;
    final monthName = homeService.getLocalizedMonth(loc, now.month);
    final year = now.year.toString();
    final monthYear = loc.monthYear(monthName, year);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Transaction> box, _) {
            final txns = box.values.toList();
            final now = DateTime.now();
            final lastMonth = DateTime(now.year, now.month - 1);

            final totalBalance = homeService.getTotalBalance(txns);
            final prevBalance = homeService.getTotalBalance(
              txns
                  .where(
                    (t) => t.dateTime.isBefore(DateTime(now.year, now.month)),
                  )
                  .toList(),
            );
            final balanceChange = homeService.percentChange(
              totalBalance,
              prevBalance,
            );

            final thisMonthExpense = homeService.getMonthExpense(txns, now);
            final lastMonthExpense = homeService.getMonthExpense(
              txns,
              lastMonth,
            );
            final expenseChange = homeService.percentChange(
              thisMonthExpense,
              lastMonthExpense,
            );

            final thisMonthIncome = homeService.getMonthIncome(txns, now);
            final lastMonthIncome = homeService.getMonthIncome(txns, lastMonth);
            final incomeChange = homeService.percentChange(
              thisMonthIncome,
              lastMonthIncome,
            );

            final catPercents = homeService.getCategoryExpensePercent(
              txns,
              now,
            );
            final catLabels = catPercents.keys
                .map((k) => appService.getCategoryLabel(loc, k))
                .toList();
            final catValues = catPercents.values.toList();

            final recentTransactions = homeService.getRecentTransactions(
              List<Transaction>.from(txns),
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    loc.appTitle,
                    style: TextStyle(
                      fontSize: 32,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontStyle: GoogleFonts.inter().fontStyle,
                    ),
                  ),
                  Text(
                    monthYear,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.7),
                      fontStyle: GoogleFonts.inter().fontStyle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    shadowColor: Theme.of(context).shadowColor,
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            loc.totalBalance,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontStyle: GoogleFonts.inter().fontStyle,
                            ),
                          ),
                          Text(
                            '₹${totalBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 32,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontStyle: GoogleFonts.inter().fontStyle,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                balanceChange >= 0
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: balanceChange >= 0
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                loc.balanceChange(
                                  balanceChange.abs().toStringAsFixed(1),
                                ),
                                style: TextStyle(
                                  color: balanceChange >= 0
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 16,
                                  fontStyle: GoogleFonts.inter().fontStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SummaryCard(
                          title: loc.thisMonth,
                          amount: "₹${thisMonthExpense.toStringAsFixed(0)}",
                          percentChange: loc.vsLastMonth(
                            expenseChange.abs().toStringAsFixed(1),
                          ),
                          isPositive: expenseChange < 0,
                          // bgColor: Theme.of(context).colorScheme.surfaceVariant,
                          bgColor: Color(0xFFEFF1FF),
                        ),
                        SizedBox(width: 12),
                        SummaryCard(
                          title: loc.income,
                          amount: "₹${thisMonthIncome.toStringAsFixed(0)}",
                          percentChange: loc.vsLastMonth(
                            incomeChange.abs().toStringAsFixed(1),
                          ),
                          isPositive: incomeChange >= 0,
                          // bgColor: Theme.of(context).colorScheme.surfaceVariant,
                          bgColor: Color(0xFFEFFFF4),
                        ),
                      ],
                    ),
                  ),
                  // Expense Categories Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loc.expenseCategories,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontStyle: GoogleFonts.inter().fontStyle,
                      ),
                    ),
                  ),
                  DynamicExpenseChart(labels: catLabels, values: catValues),
                  // Recent Transaction Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loc.recentTransactions,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontStyle: GoogleFonts.inter().fontStyle,
                      ),
                    ),
                  ),
                  if (recentTransactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        loc.noTransactions,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: recentTransactions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final txn = recentTransactions[index];
                        final iconData = addExpenseService
                            .getCategoryIconAndColor(txn.category);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: TransactionCard(
                            icon: iconData['icon'] as IconData,
                            iconColor: iconData['color'] as Color,
                            iconBgColor: iconData['bgColor'] as Color,
                            transaction: appService.getCategoryLabel(
                              loc,
                              txn.category,
                            ),
                            time:
                                "${txn.dateTime.year}-${txn.dateTime.month.toString().padLeft(2, '0')}-${txn.dateTime.day.toString().padLeft(2, '0')} ${txn.dateTime.hour.toString().padLeft(2, '0')}:${txn.dateTime.minute.toString().padLeft(2, '0')}",
                            amount: txn.isIncome
                                ? "+${txn.amount}"
                                : "-${txn.amount}",
                            isDebit: !txn.isIncome,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Add this widget in e:\Apps\khata\lib\features\home\widgets\chart_analytics.dart
class DynamicExpenseChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;

  const DynamicExpenseChart({
    super.key,
    required this.labels,
    required this.values,
    this.colors = const [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.grey,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ],
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (values.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(loc.noExpenseData),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartSize = constraints.maxWidth * 0.4;
        final legendSpacing = constraints.maxWidth * 0.05;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: chartSize * 0.25,
                  sections: List.generate(values.length, (i) {
                    return PieChartSectionData(
                      color: colors[i % colors.length],
                      value: values[i],
                      title: '',
                      radius: chartSize * 0.15,
                    );
                  }),
                ),
              ),
            ),
            SizedBox(width: legendSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(labels.length, (i) {
                  return LegendItem(
                    color: colors[i % colors.length],
                    text: labels[i],
                    percentage: "${values[i].toStringAsFixed(0)}%",
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
