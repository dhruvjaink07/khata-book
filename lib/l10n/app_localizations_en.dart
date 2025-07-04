// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Khata';

  @override
  String monthYear(Object month, Object year) {
    return '$month $year';
  }

  @override
  String get totalBalance => 'Total Balance';

  @override
  String balanceChange(Object percentage) {
    return '$percentage% this month';
  }

  @override
  String get thisMonth => 'This Month';

  @override
  String get income => 'Income';

  @override
  String vsLastMonth(Object percentage) {
    return '$percentage% vs last month';
  }

  @override
  String get expenseCategories => 'Expense Categories';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactions => 'No transactions yet.';

  @override
  String get noExpenseData => 'No expense data for this month.';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get housing => 'Housing';

  @override
  String get food => 'Food';

  @override
  String get transport => 'Transport';

  @override
  String get shopping => 'Shopping';

  @override
  String get others => 'Others';

  @override
  String get debit => 'Debit';

  @override
  String get credit => 'Credit';

  @override
  String get amount => 'Amount';

  @override
  String get percentChange => 'Percent Change';

  @override
  String get positiveChange => 'Increase';

  @override
  String get negativeChange => 'Decrease';

  @override
  String get category => 'Category';

  @override
  String get percentage => 'Percentage';

  @override
  String get noData => 'No data available.';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred.';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get expense => 'Expense';

  @override
  String get incomeType => 'Income';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountHint => '0.00';

  @override
  String get categoryLabel => 'Category';

  @override
  String get categoryHint => 'Category';

  @override
  String get dateLabel => 'Date';

  @override
  String get notesLabel => 'Notes (Optional)';

  @override
  String get notesHint => 'Add notes here...';

  @override
  String get save => 'Save';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get transactionAdded => 'Transaction added!';

  @override
  String get foodAndDining => 'Food & Dining';

  @override
  String get groceries => 'Groceries';

  @override
  String get healthAndFitness => 'Health & Fitness';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get utilities => 'Utilities';

  @override
  String get rent => 'Rent';

  @override
  String get travel => 'Travel';

  @override
  String get education => 'Education';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get insurance => 'Insurance';

  @override
  String get personalCare => 'Personal Care';

  @override
  String get giftsAndDonations => 'Gifts & Donations';

  @override
  String get othersCategory => 'Others';

  @override
  String get salary => 'Salary';

  @override
  String get freelance => 'Freelance';

  @override
  String get interest => 'Interest';

  @override
  String get investments => 'Investments';

  @override
  String get gifts => 'Gifts';

  @override
  String get rentalIncome => 'Rental Income';

  @override
  String get refunds => 'Refunds';

  @override
  String get otherIncome => 'Other Income';

  @override
  String get searchTransactions => 'Search transactions...';

  @override
  String get filterAll => 'All';

  @override
  String get filterThisMonth => 'This Month';

  @override
  String get filterGroceries => 'Groceries';

  @override
  String get filterShopping => 'Shopping';

  @override
  String get filterSalary => 'Salary';

  @override
  String get filterRent => 'Rent';

  @override
  String get filterTravel => 'Travel';

  @override
  String get filterOthers => 'Others';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get transaction => 'Transaction';

  @override
  String get noTransactionsFound => 'No transactions found.';

  @override
  String amountCurrency(Object sign, Object currency, Object amount) {
    return '$sign$currency$amount';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navAdd => 'Add';

  @override
  String get navList => 'List';

  @override
  String get navReports => 'Reports';

  @override
  String get navSettings => 'Settings';

  @override
  String get myAnalytics => 'My Analytics';

  @override
  String get addAtLeast3Transactions => 'Add at least 3 transactions to view analytics.';

  @override
  String get dailyExpenses => 'Daily Expenses';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get highestSpending => 'Highest Spending';

  @override
  String get biggestChange => 'Biggest Change';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get viewDetailedReport => 'View Detailed Report';

  @override
  String onCategory(Object category) {
    return 'on $category';
  }

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get settings => 'Settings';

  @override
  String get languageRegion => 'Language & Region';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get largeTextMode => 'Large Text Mode';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get backupFrequency => 'Backup Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get cloudSyncAndSharing => 'Cloud Sync & Sharing';

  @override
  String get signInToSync => 'Sign In to Sync';

  @override
  String get partnerEmailLabel => 'Partner Email (only one allowed)';

  @override
  String get partnerEmailHint => 'Enter partner\'s email to share';

  @override
  String get partnerLockedHint => 'Partner email is locked. You can\'t change it.';

  @override
  String get onlyOnePartnerInfo => 'You can only share with one partner. Leave blank to keep private.';

  @override
  String get exportAndShareKhata => 'Export & Share Khata';

  @override
  String get syncFromCloud => 'Sync from Cloud';

  @override
  String get leaveSharedAccount => 'Leave Shared Account';

  @override
  String get shareAccount => 'Share Account';

  @override
  String get joinAccount => 'Join Account';

  @override
  String get noMembersYet => 'No members yet.';

  @override
  String get accountMembers => 'Account Members';

  @override
  String get shareQrToInvite => 'Share your QR code to invite others.';

  @override
  String get youAreAMemberOf => 'You are a member of:';

  @override
  String get remove => 'Remove';

  @override
  String get memberInfo => 'As a member, you can view and add transactions to this shared account. Only the account owner can manage members.';

  @override
  String get shareKhataAccount => 'Share Khata Account';

  @override
  String get shareYourKhataAccount => 'Share Your Khata Account';

  @override
  String get letOthersScanQr => 'Let others scan this QR code to join your account and share expenses';

  @override
  String get failedToGenerateQr => 'Failed to generate QR code';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get qrExpiresIn10Min => 'This QR code expires in 10 minutes';

  @override
  String get max5Members => 'Maximum 5 members can join your account';

  @override
  String get generateNewQr => 'Generate New QR Code';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get positionQrInFrame => 'Position the QR code within the frame';

  @override
  String get cameraWillScanAutomatically => 'The camera will automatically scan when a QR code is detected';

  @override
  String get successfullyJoinedSharedAccount => 'Successfully joined the shared account!';
}
