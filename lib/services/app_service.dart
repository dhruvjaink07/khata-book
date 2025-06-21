import 'package:khata/l10n/app_localizations.dart';

class AppService {
  String getCategoryLabel(AppLocalizations loc, String key) {
    switch (key) {
      case 'foodAndDining':
        return loc.foodAndDining;
      case 'groceries':
        return loc.groceries;
      case 'transport':
        return loc.transport;
      case 'healthAndFitness':
        return loc.healthAndFitness;
      case 'shopping':
        return loc.shopping;
      case 'entertainment':
        return loc.entertainment;
      case 'utilities':
        return loc.utilities;
      case 'rent':
        return loc.rent;
      case 'travel':
        return loc.travel;
      case 'education':
        return loc.education;
      case 'subscriptions':
        return loc.subscriptions;
      case 'insurance':
        return loc.insurance;
      case 'personalCare':
        return loc.personalCare;
      case 'giftsAndDonations':
        return loc.giftsAndDonations;
      case 'othersCategory':
        return loc.othersCategory;
      case 'salary':
        return loc.salary;
      case 'freelance':
        return loc.freelance;
      case 'interest':
        return loc.interest;
      case 'investments':
        return loc.investments;
      case 'gifts':
        return loc.gifts;
      case 'rentalIncome':
        return loc.rentalIncome;
      case 'refunds':
        return loc.refunds;
      case 'otherIncome':
        return loc.otherIncome;
      default:
        return key;
    }
  }

  String monthName(int month, AppLocalizations loc) {
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
