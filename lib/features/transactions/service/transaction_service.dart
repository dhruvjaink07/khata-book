import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:khata/l10n/app_localizations.dart';

class TransactionService {
  List<Transaction> filterTransactions(
    List<Transaction> transactions,
    String? selectedFilter,
    AppLocalizations loc,
    String Function(AppLocalizations, String) getCategoryLabel,
  ) {
    if (selectedFilter == null || selectedFilter == loc.filterAll) {
      return transactions;
    } else if (selectedFilter == loc.filterThisMonth) {
      final now = DateTime.now();
      return transactions
          .where(
            (txn) =>
                txn.dateTime.year == now.year &&
                txn.dateTime.month == now.month,
          )
          .toList();
    } else {
      return transactions
          .where((txn) => getCategoryLabel(loc, txn.category) == selectedFilter)
          .toList();
    }
  }

  Map<String, List<Transaction>> groupTransactions(
    List<Transaction> txns,
    AppLocalizations loc,
  ) {
    final Map<String, List<Transaction>> grouped = {};
    final now = DateTime.now();

    for (var txn in txns) {
      String key;

      if (_isSameDay(txn.dateTime, now)) {
        key = loc.today;
      } else if (_isSameDay(txn.dateTime, now.subtract(Duration(days: 1)))) {
        key = loc.yesterday;
      } else {
        key =
            "${txn.dateTime.day} ${_monthName(txn.dateTime.month, loc)} ${txn.dateTime.year}";
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(txn);
    }

    return grouped;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month, AppLocalizations loc) {
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
