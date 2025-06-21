import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:khata/l10n/app_localizations.dart';

class HomeService {
  List<Transaction> getRecentTransactions(List<Transaction> txns) {
    txns.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return txns.take(5).toList();
  }

  double getTotalBalance(List<Transaction> txns) {
    double income = txns
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    double expense = txns
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    return income - expense;
  }

  double getMonthExpense(List<Transaction> txns, DateTime date) {
    return txns
        .where(
          (t) =>
              !t.isIncome &&
              t.dateTime.year == date.year &&
              t.dateTime.month == date.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getMonthIncome(List<Transaction> txns, DateTime date) {
    return txns
        .where(
          (t) =>
              t.isIncome &&
              t.dateTime.year == date.year &&
              t.dateTime.month == date.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double percentChange(double current, double previous) {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  Map<String, double> getCategoryExpensePercent(
    List<Transaction> txns,
    DateTime date,
  ) {
    final Map<String, double> catTotals = {};
    double total = 0;
    for (var t in txns) {
      if (!t.isIncome &&
          t.dateTime.year == date.year &&
          t.dateTime.month == date.month) {
        catTotals[t.category] = (catTotals[t.category] ?? 0) + t.amount;
        total += t.amount;
      }
    }
    if (total > 0) {
      catTotals.updateAll((k, v) => (v / total) * 100);
    }
    return catTotals;
  }

  String getLocalizedMonth(AppLocalizations loc, int month) {
    switch (month) {
      case 1:
        return loc.january;
      case 2:
        return loc.february;
      case 3:
        return loc.march;
      case 4:
        return loc.april;
      case 5:
        return loc.may;
      case 6:
        return loc.june;
      case 7:
        return loc.july;
      case 8:
        return loc.august;
      case 9:
        return loc.september;
      case 10:
        return loc.october;
      case 11:
        return loc.november;
      case 12:
        return loc.december;
      default:
        return '';
    }
  }
}
