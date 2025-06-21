import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata/features/reports/service/analytics_service.dart';
import 'package:khata/features/reports/widgets/category_pie_chart.dart';
import 'package:khata/features/reports/widgets/daily_bar_chart.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'package:khata/services/app_service.dart';
import '../../features/transactions/domain/transaction.dart';

// Finds highest spending category (for current month)
MapEntry<String, double>? getHighestSpending(Map<String, double> cat) {
  if (cat.isEmpty) return null;
  return cat.entries.reduce((a, b) => a.value > b.value ? a : b);
}

class AnalyticsScreen extends StatelessWidget {
  final Box<Transaction> box = Hive.box<Transaction>('transactions');
  final List<Color> categoryColors = [
    Color(0xffFF6B6B),
    Color(0xff4ECDC4),
    Color(0xffFFD93D),
    Color(0xff6C5CE7),
    Color(0xffA8A8A8),
  ];
  final AnalyticsService analyticsService = AnalyticsService();
  final AppService appService = AppService();

  AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<Transaction> box, _) {
            final txns = box.values.toList();

            // Only show analytics if there are at least 3 transactions
            if (txns.length < 3) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      SizedBox(height: 24),
                      Text(
                        loc.addAtLeast3Transactions,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final totalExpenses = analyticsService.getTotalExpenses(txns);
            final dailyMap = analyticsService.getDailyExpenses(txns, loc);
            final dailyValues = dailyMap.values.toList();
            final dailyLabels = dailyMap.keys.toList();
            final catMap = analyticsService.getCategoryExpenses(txns);
            final catValues = catMap.values.toList();
            final catLabels = catMap.keys
                .map((k) => appService.getCategoryLabel(loc, k))
                .toList();
            final highest = analyticsService.getHighestSpending(catMap);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(loc, colorScheme),
                    SizedBox(height: 16),
                    _buildTotalExpensesCard(loc, totalExpenses, colorScheme),
                    SizedBox(height: 24),
                    DailyBarChart(
                      title: loc.dailyExpenses,
                      values: dailyValues,
                      xLabels: dailyLabels,
                      maxY: (dailyValues.isNotEmpty)
                          ? (dailyValues.reduce((a, b) => a > b ? a : b) * 1.2)
                                .ceilToDouble()
                          : 1000,
                      interval:
                          (dailyValues.isNotEmpty &&
                              dailyValues.reduce((a, b) => a > b ? a : b) > 0)
                          ? (dailyValues.reduce((a, b) => a > b ? a : b) / 4)
                                .ceilToDouble()
                          : 250,
                    ),
                    SizedBox(height: 24),
                    CategoryPieChart(
                      title: loc.spendingByCategory,
                      values: catValues,
                      colors: categoryColors,
                      labels: catLabels,
                    ),
                    SizedBox(height: 24),
                    _buildSummaryCards(loc, highest, colorScheme),
                    // SizedBox(height: 24),
                    // _buildViewReportButton(loc, colorScheme),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc, ColorScheme colorScheme) {
    return Row(
      children: [
        Text(
          loc.myAnalytics,
          style: GoogleFonts.inter(
            fontSize: 26,
            color: colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalExpensesCard(
    AppLocalizations loc,
    double totalExpenses,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "₹${totalExpenses.toStringAsFixed(0)}",
            style: TextStyle(
              fontStyle: GoogleFonts.inter().fontStyle,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            loc.totalExpenses,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontStyle: GoogleFonts.inter().fontStyle,
            ),
          ),
          SizedBox(height: 8),
          // For demo, you can add a placeholder for % change
          Text(
            "+12% ${loc.vsLastMonth('')}",
            style: TextStyle(
              color: Colors.red,
              fontStyle: GoogleFonts.inter().fontStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    AppLocalizations loc,
    MapEntry<String, double>? highest,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surfaceVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shopping_cart, color: Colors.red),
                SizedBox(height: 8),
                Text(
                  loc.highestSpending,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  highest != null
                      ? "₹${highest.value.toStringAsFixed(0)} ${loc.onCategory(appService.getCategoryLabel(loc, highest.key))}"
                      : loc.noData,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surfaceVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.directions_bus, color: Colors.green),
                SizedBox(height: 8),
                Text(
                  loc.biggestChange,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  loc.comingSoon,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
