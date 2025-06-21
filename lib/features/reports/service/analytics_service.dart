import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:khata/l10n/app_localizations.dart';

class AnalyticsService {
  double getTotalExpenses(List<Transaction> txns) {
    final now = DateTime.now();
    return txns
        .where(
          (t) =>
              !t.isIncome &&
              t.dateTime.year == now.year &&
              t.dateTime.month == now.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getDailyExpenses(
    List<Transaction> txns,
    AppLocalizations loc,
  ) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    Map<String, double> daily = {};
    final weekLabels = [
      loc.monday,
      loc.tuesday,
      loc.wednesday,
      loc.thursday,
      loc.friday,
      loc.saturday,
      loc.sunday,
    ];
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final label = weekLabels[i];
      daily[label] = txns
          .where(
            (t) =>
                !t.isIncome &&
                t.dateTime.year == day.year &&
                t.dateTime.month == day.month &&
                t.dateTime.day == day.day,
          )
          .fold(0.0, (sum, t) => sum + t.amount);
    }
    return daily;
  }

  Map<String, double> getCategoryExpenses(List<Transaction> txns) {
    final now = DateTime.now();
    Map<String, double> cat = {};
    for (final t in txns) {
      if (!t.isIncome &&
          t.dateTime.year == now.year &&
          t.dateTime.month == now.month) {
        cat[t.category] = (cat[t.category] ?? 0) + t.amount;
      }
    }
    return cat;
  }

  MapEntry<String, double>? getHighestSpending(Map<String, double> cat) {
    if (cat.isEmpty) return null;
    return cat.entries.reduce((a, b) => a.value > b.value ? a : b);
  }
}
