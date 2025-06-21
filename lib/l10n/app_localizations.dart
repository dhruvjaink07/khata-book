import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Khata'**
  String get appTitle;

  /// Displays the month and year like 'June 2025'
  ///
  /// In en, this message translates to:
  /// **'{month} {year}'**
  String monthYear(Object month, Object year);

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// Shows the percentage change in balance for this month
  ///
  /// In en, this message translates to:
  /// **'{percentage}% this month'**
  String balanceChange(Object percentage);

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// Shows the percentage change compared to last month
  ///
  /// In en, this message translates to:
  /// **'{percentage}% vs last month'**
  String vsLastMonth(Object percentage);

  /// No description provided for @expenseCategories.
  ///
  /// In en, this message translates to:
  /// **'Expense Categories'**
  String get expenseCategories;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get noTransactions;

  /// No description provided for @noExpenseData.
  ///
  /// In en, this message translates to:
  /// **'No expense data for this month.'**
  String get noExpenseData;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @housing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get housing;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @percentChange.
  ///
  /// In en, this message translates to:
  /// **'Percent Change'**
  String get percentChange;

  /// No description provided for @positiveChange.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get positiveChange;

  /// No description provided for @negativeChange.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get negativeChange;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred.'**
  String get error;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeType;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryHint;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes here...'**
  String get notesHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @transactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added!'**
  String get transactionAdded;

  /// No description provided for @foodAndDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get foodAndDining;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @healthAndFitness.
  ///
  /// In en, this message translates to:
  /// **'Health & Fitness'**
  String get healthAndFitness;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @personalCare.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get personalCare;

  /// No description provided for @giftsAndDonations.
  ///
  /// In en, this message translates to:
  /// **'Gifts & Donations'**
  String get giftsAndDonations;

  /// No description provided for @othersCategory.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get othersCategory;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @freelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @investments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get investments;

  /// No description provided for @gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get gifts;

  /// No description provided for @rentalIncome.
  ///
  /// In en, this message translates to:
  /// **'Rental Income'**
  String get rentalIncome;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @otherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get otherIncome;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get searchTransactions;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get filterThisMonth;

  /// No description provided for @filterGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get filterGroceries;

  /// No description provided for @filterShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get filterShopping;

  /// No description provided for @filterSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get filterSalary;

  /// No description provided for @filterRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get filterRent;

  /// No description provided for @filterTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get filterTravel;

  /// No description provided for @filterOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get filterOthers;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found.'**
  String get noTransactionsFound;

  /// Transaction amount with sign, currency, and value
  ///
  /// In en, this message translates to:
  /// **'{sign}{currency}{amount}'**
  String amountCurrency(Object sign, Object currency, Object amount);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get navList;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @myAnalytics.
  ///
  /// In en, this message translates to:
  /// **'My Analytics'**
  String get myAnalytics;

  /// No description provided for @addAtLeast3Transactions.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 transactions to view analytics.'**
  String get addAtLeast3Transactions;

  /// No description provided for @dailyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Daily Expenses'**
  String get dailyExpenses;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by Category'**
  String get spendingByCategory;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @highestSpending.
  ///
  /// In en, this message translates to:
  /// **'Highest Spending'**
  String get highestSpending;

  /// No description provided for @biggestChange.
  ///
  /// In en, this message translates to:
  /// **'Biggest Change'**
  String get biggestChange;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @viewDetailedReport.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Report'**
  String get viewDetailedReport;

  /// Used in analytics summary: e.g. '₹500 on Food'
  ///
  /// In en, this message translates to:
  /// **'on {category}'**
  String onCategory(Object category);

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @languageRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get languageRegion;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @largeTextMode.
  ///
  /// In en, this message translates to:
  /// **'Large Text Mode'**
  String get largeTextMode;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @autoBackup.
  ///
  /// In en, this message translates to:
  /// **'Auto Backup'**
  String get autoBackup;

  /// No description provided for @backupFrequency.
  ///
  /// In en, this message translates to:
  /// **'Backup Frequency'**
  String get backupFrequency;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @cloudSyncAndSharing.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync & Sharing'**
  String get cloudSyncAndSharing;

  /// No description provided for @signInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign In to Sync'**
  String get signInToSync;

  /// No description provided for @partnerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Partner Email (only one allowed)'**
  String get partnerEmailLabel;

  /// No description provided for @partnerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter partner\'s email to share'**
  String get partnerEmailHint;

  /// No description provided for @partnerLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Partner email is locked. You can\'t change it.'**
  String get partnerLockedHint;

  /// No description provided for @onlyOnePartnerInfo.
  ///
  /// In en, this message translates to:
  /// **'You can only share with one partner. Leave blank to keep private.'**
  String get onlyOnePartnerInfo;

  /// No description provided for @exportAndShareKhata.
  ///
  /// In en, this message translates to:
  /// **'Export & Share Khata'**
  String get exportAndShareKhata;

  /// No description provided for @syncFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Sync from Cloud'**
  String get syncFromCloud;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'gu', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'gu': return AppLocalizationsGu();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
