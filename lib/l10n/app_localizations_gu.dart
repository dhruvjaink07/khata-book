// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'મારું ખાતું';

  @override
  String monthYear(Object month, Object year) {
    return '$month $year';
  }

  @override
  String get totalBalance => 'કુલ બેલેન્સ';

  @override
  String balanceChange(Object percentage) {
    return 'આ મહિને $percentage%';
  }

  @override
  String get thisMonth => 'આ મહિનો';

  @override
  String get income => 'આવક';

  @override
  String vsLastMonth(Object percentage) {
    return 'ગયા મહિને કરતાં $percentage%';
  }

  @override
  String get expenseCategories => 'ખર્ચ કેટેગરીઝ';

  @override
  String get recentTransactions => 'તાજેતરના વ્યવહારો';

  @override
  String get noTransactions => 'હજુ સુધી કોઈ વ્યવહાર નથી.';

  @override
  String get noExpenseData => 'આ મહિના માટે કોઈ ખર્ચ માહિતી નથી.';

  @override
  String get january => 'જાન્યુઆરી';

  @override
  String get february => 'ફેબ્રુઆરી';

  @override
  String get march => 'માર્ચ';

  @override
  String get april => 'એપ્રિલ';

  @override
  String get may => 'મે';

  @override
  String get june => 'જૂન';

  @override
  String get july => 'જુલાઈ';

  @override
  String get august => 'ઑગસ્ટ';

  @override
  String get september => 'સપ્ટેમ્બર';

  @override
  String get october => 'ઑક્ટોબર';

  @override
  String get november => 'નવેમ્બર';

  @override
  String get december => 'ડિસેમ્બર';

  @override
  String get housing => 'રહેઠાણ';

  @override
  String get food => 'ખોરાક';

  @override
  String get transport => 'પરિવહન';

  @override
  String get shopping => 'ખરીદી';

  @override
  String get others => 'અન્ય';

  @override
  String get debit => 'ડેબિટ';

  @override
  String get credit => 'ક્રેડિટ';

  @override
  String get amount => 'રકમ';

  @override
  String get percentChange => 'ટકાવારી ફેરફાર';

  @override
  String get positiveChange => 'વધારો';

  @override
  String get negativeChange => 'ઘટાડો';

  @override
  String get category => 'કેટેગરી';

  @override
  String get percentage => 'ટકાવારી';

  @override
  String get noData => 'માહિતી ઉપલબ્ધ નથી.';

  @override
  String get loading => 'લોડ થઈ રહ્યું છે...';

  @override
  String get error => 'કોઈ ભૂલ આવી છે.';

  @override
  String get addTransaction => 'વ્યવહાર ઉમેરો';

  @override
  String get expense => 'ખર્ચ';

  @override
  String get incomeType => 'આવક';

  @override
  String get amountLabel => 'રકમ';

  @override
  String get amountHint => '૦.૦૦';

  @override
  String get categoryLabel => 'કેટેગરી';

  @override
  String get categoryHint => 'કેટેગરી';

  @override
  String get dateLabel => 'તારીખ';

  @override
  String get notesLabel => 'નોંધો (વૈકલ્પિક)';

  @override
  String get notesHint => 'અહીં નોંધો ઉમેરો...';

  @override
  String get save => 'સેવ કરો';

  @override
  String get pleaseSelectCategory => 'કૃપા કરીને કેટેગરી પસંદ કરો';

  @override
  String get pleaseEnterValidAmount => 'કૃપા કરીને માન્ય રકમ દાખલ કરો';

  @override
  String get transactionAdded => 'વ્યવહાર ઉમેરાયો!';

  @override
  String get foodAndDining => 'ખોરાક અને ભોજન';

  @override
  String get groceries => 'કિરાણા';

  @override
  String get healthAndFitness => 'આરોગ્ય અને ફિટનેસ';

  @override
  String get entertainment => 'મનોરંજન';

  @override
  String get utilities => 'યુટિલિટીઝ';

  @override
  String get rent => 'ભાડું';

  @override
  String get travel => 'પ્રવાસ';

  @override
  String get education => 'શિક્ષણ';

  @override
  String get subscriptions => 'સબ્સ્ક્રિપ્શન';

  @override
  String get insurance => 'વીમા';

  @override
  String get personalCare => 'વ્યક્તિગત કાળજી';

  @override
  String get giftsAndDonations => 'ભેટ અને દાન';

  @override
  String get othersCategory => 'અન્ય';

  @override
  String get salary => 'પગાર';

  @override
  String get freelance => 'ફ્રીલાન્સ';

  @override
  String get interest => 'વ્યાજ';

  @override
  String get investments => 'નિવેશ';

  @override
  String get gifts => 'ભેટ';

  @override
  String get rentalIncome => 'ભાડાની આવક';

  @override
  String get refunds => 'પરતફેર';

  @override
  String get otherIncome => 'અન્ય આવક';

  @override
  String get searchTransactions => 'વ્યવહારો શોધો...';

  @override
  String get filterAll => 'બધા';

  @override
  String get filterThisMonth => 'આ મહિનો';

  @override
  String get filterGroceries => 'કિરાણા';

  @override
  String get filterShopping => 'ખરીદી';

  @override
  String get filterSalary => 'પગાર';

  @override
  String get filterRent => 'ભાડું';

  @override
  String get filterTravel => 'પ્રવાસ';

  @override
  String get filterOthers => 'અન્ય';

  @override
  String get today => 'આજે';

  @override
  String get yesterday => 'ગઈકાલે';

  @override
  String get transaction => 'વ્યવહાર';

  @override
  String get noTransactionsFound => 'કોઈ વ્યવહાર મળ્યા નથી.';

  @override
  String amountCurrency(Object sign, Object currency, Object amount) {
    return '$sign$currency$amount';
  }

  @override
  String get navHome => 'હોમ';

  @override
  String get navAdd => 'ઉમેરો';

  @override
  String get navList => 'યાદી';

  @override
  String get navReports => 'અહેવાલ';

  @override
  String get navSettings => 'સેટિંગ્સ';

  @override
  String get myAnalytics => 'મારું વિશ્લેષણ';

  @override
  String get addAtLeast3Transactions => 'વિશ્લેષણ જોવા માટે ઓછામાં ઓછા ૩ વ્યવહાર ઉમેરો.';

  @override
  String get dailyExpenses => 'દૈનિક ખર્ચ';

  @override
  String get spendingByCategory => 'કેટેગરી પ્રમાણે ખર્ચ';

  @override
  String get totalExpenses => 'કુલ ખર્ચ';

  @override
  String get highestSpending => 'સૌથી વધુ ખર્ચ';

  @override
  String get biggestChange => 'મોટો ફેરફાર';

  @override
  String get comingSoon => 'આવતી કાલે';

  @override
  String get viewDetailedReport => 'વિગતવાર અહેવાલ જુઓ';

  @override
  String onCategory(Object category) {
    return '$category પર';
  }

  @override
  String get monday => 'સોમ';

  @override
  String get tuesday => 'મંગળ';

  @override
  String get wednesday => 'બુધ';

  @override
  String get thursday => 'ગુરુ';

  @override
  String get friday => 'શુક્ર';

  @override
  String get saturday => 'શનિ';

  @override
  String get sunday => 'રવિ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get languageRegion => 'ભાષા અને પ્રદેશ';

  @override
  String get language => 'ભાષા';

  @override
  String get currency => 'ચલણ';

  @override
  String get appearance => 'દેખાવ';

  @override
  String get darkMode => 'ડાર્ક મોડ';

  @override
  String get largeTextMode => 'મોટા અક્ષરો મોડ';

  @override
  String get dataManagement => 'ડેટા મેનેજમેન્ટ';

  @override
  String get autoBackup => 'ઓટો બેકઅપ';

  @override
  String get backupFrequency => 'બેકઅપ આવૃત્તિ';

  @override
  String get daily => 'દૈનિક';

  @override
  String get cloudSyncAndSharing => 'ક્લાઉડ સિંક અને શેરિંગ';

  @override
  String get signInToSync => 'સિંક માટે સાઇન ઇન કરો';

  @override
  String get partnerEmailLabel => 'પાર્ટનર ઇમેઇલ (માત્ર એકની મંજૂરી)';

  @override
  String get partnerEmailHint => 'શેર કરવા માટે પાર્ટનરનો ઇમેઇલ દાખલ કરો';

  @override
  String get partnerLockedHint => 'પાર્ટનર ઇમેઇલ લોક છે. તમે તેને બદલી શકતા નથી.';

  @override
  String get onlyOnePartnerInfo => 'તમે માત્ર એક પાર્ટનર સાથે શેર કરી શકો છો. ખાનગી રાખવા માટે ખાલી રાખો.';

  @override
  String get exportAndShareKhata => 'ખાતા એક્સપોર્ટ અને શેર કરો';

  @override
  String get syncFromCloud => 'ક્લાઉડમાંથી સિંક કરો';

  @override
  String get leaveSharedAccount => 'શેર કરેલું ખાતું છોડો';

  @override
  String get shareAccount => 'ખાતું શેર કરો';

  @override
  String get joinAccount => 'ખાતામાં જોડાઓ';

  @override
  String get noMembersYet => 'હજુ સુધી કોઈ સભ્ય નથી.';

  @override
  String get accountMembers => 'ખાતાના સભ્યો';

  @override
  String get shareQrToInvite => 'અન્યને આમંત્રિત કરવા માટે તમારો QR કોડ શેર કરો.';

  @override
  String get youAreAMemberOf => 'તમે આ ખાતાના સભ્ય છો:';

  @override
  String get remove => 'દૂર કરો';

  @override
  String get memberInfo => 'સભ્ય તરીકે, તમે આ શેર કરેલા ખાતામાં વ્યવહારો જોઈ અને ઉમેરી શકો છો. માત્ર ખાતા માલિક જ સભ્યોનું સંચાલન કરી શકે છે.';

  @override
  String get shareKhataAccount => 'ખાતે શેર કરો';

  @override
  String get shareYourKhataAccount => 'તમે ખાતું શેર કરો';

  @override
  String get letOthersScanQr => 'ઇતર લોકોને આ QR કોડ સ્કેન કરવા દો જેથી તેઓ તમારા ખાતામાં જોડાઈ શકે અને ખર્ચ શેર કરી શકે';

  @override
  String get failedToGenerateQr => 'QR કોડ બનાવવામાં નિષ્ફળ';

  @override
  String get tryAgain => 'ફરીથી પ્રયાસ કરો';

  @override
  String get qrExpiresIn10Min => 'આ QR કોડ 10 મિનિટમાં સમાપ્ત થશે';

  @override
  String get max5Members => 'તમારા ખાતામાં મહત્તમ 5 સભ્યો સામેલ થઈ શકે છે';

  @override
  String get generateNewQr => 'નવો QR કોડ બનાવો';

  @override
  String get scanQrCode => 'QR કોડ સ્કેન કરો';

  @override
  String get positionQrInFrame => 'QR કોડને ફ્રેમની અંદર રાખો';

  @override
  String get cameraWillScanAutomatically => 'QR કોડ ઓળખાય ત્યારે કેમેરા આપમેળે સ્કેન કરશે';

  @override
  String get successfullyJoinedSharedAccount => 'શેર કરેલા ખાતામાં સફળતાપૂર્વક જોડાયા!';
}
