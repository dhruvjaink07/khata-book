// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'माझा खाता';

  @override
  String monthYear(Object month, Object year) {
    return '$month $year';
  }

  @override
  String get totalBalance => 'एकूण शिल्लक';

  @override
  String balanceChange(Object percentage) {
    return 'या महिन्यात $percentage%';
  }

  @override
  String get thisMonth => 'हा महिना';

  @override
  String get income => 'उत्पन्न';

  @override
  String vsLastMonth(Object percentage) {
    return 'मागील महिन्यापेक्षा $percentage%';
  }

  @override
  String get expenseCategories => 'खर्च श्रेणी';

  @override
  String get recentTransactions => 'अलीकडील व्यवहार';

  @override
  String get noTransactions => 'अजून कोणतेही व्यवहार नाहीत.';

  @override
  String get noExpenseData => 'या महिन्यासाठी खर्चाची माहिती नाही.';

  @override
  String get january => 'जानेवारी';

  @override
  String get february => 'फेब्रुवारी';

  @override
  String get march => 'मार्च';

  @override
  String get april => 'एप्रिल';

  @override
  String get may => 'मे';

  @override
  String get june => 'जून';

  @override
  String get july => 'जुलै';

  @override
  String get august => 'ऑगस्ट';

  @override
  String get september => 'सप्टेंबर';

  @override
  String get october => 'ऑक्टोबर';

  @override
  String get november => 'नोव्हेंबर';

  @override
  String get december => 'डिसेंबर';

  @override
  String get housing => 'निवास';

  @override
  String get food => 'अन्न';

  @override
  String get transport => 'वाहतूक';

  @override
  String get shopping => 'खरेदी';

  @override
  String get others => 'इतर';

  @override
  String get debit => 'डेबिट';

  @override
  String get credit => 'क्रेडिट';

  @override
  String get amount => 'रक्कम';

  @override
  String get percentChange => 'टक्केवारी बदल';

  @override
  String get positiveChange => 'वाढ';

  @override
  String get negativeChange => 'कमी';

  @override
  String get category => 'श्रेणी';

  @override
  String get percentage => 'टक्केवारी';

  @override
  String get noData => 'माहिती उपलब्ध नाही.';

  @override
  String get loading => 'लोड होत आहे...';

  @override
  String get error => 'त्रुटी आली आहे.';

  @override
  String get addTransaction => 'व्यवहार जोडा';

  @override
  String get expense => 'खर्च';

  @override
  String get incomeType => 'उत्पन्न';

  @override
  String get amountLabel => 'रक्कम';

  @override
  String get amountHint => '०.००';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get categoryHint => 'श्रेणी';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get notesLabel => 'नोंदी (ऐच्छिक)';

  @override
  String get notesHint => 'येथे नोंदी जोडा...';

  @override
  String get save => 'जतन करा';

  @override
  String get pleaseSelectCategory => 'कृपया श्रेणी निवडा';

  @override
  String get pleaseEnterValidAmount => 'कृपया वैध रक्कम प्रविष्ट करा';

  @override
  String get transactionAdded => 'व्यवहार जोडला!';

  @override
  String get foodAndDining => 'अन्न व जेवण';

  @override
  String get groceries => 'किराणा';

  @override
  String get healthAndFitness => 'आरोग्य व फिटनेस';

  @override
  String get entertainment => 'मनोरंजन';

  @override
  String get utilities => 'उपयुक्तता';

  @override
  String get rent => 'भाडे';

  @override
  String get travel => 'प्रवास';

  @override
  String get education => 'शिक्षण';

  @override
  String get subscriptions => 'सदस्यता';

  @override
  String get insurance => 'विमा';

  @override
  String get personalCare => 'वैयक्तिक काळजी';

  @override
  String get giftsAndDonations => 'भेटवस्तू व देणगी';

  @override
  String get othersCategory => 'इतर';

  @override
  String get salary => 'पगार';

  @override
  String get freelance => 'फ्रीलान्स';

  @override
  String get interest => 'व्याज';

  @override
  String get investments => 'गुंतवणूक';

  @override
  String get gifts => 'भेटवस्तू';

  @override
  String get rentalIncome => 'भाड्याचे उत्पन्न';

  @override
  String get refunds => 'परतावा';

  @override
  String get otherIncome => 'इतर उत्पन्न';

  @override
  String get searchTransactions => 'व्यवहार शोधा...';

  @override
  String get filterAll => 'सर्व';

  @override
  String get filterThisMonth => 'हा महिना';

  @override
  String get filterGroceries => 'किराणा';

  @override
  String get filterShopping => 'खरेदी';

  @override
  String get filterSalary => 'पगार';

  @override
  String get filterRent => 'भाडे';

  @override
  String get filterTravel => 'प्रवास';

  @override
  String get filterOthers => 'इतर';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'काल';

  @override
  String get transaction => 'व्यवहार';

  @override
  String get noTransactionsFound => 'कोणतेही व्यवहार सापडले नाहीत.';

  @override
  String amountCurrency(Object sign, Object currency, Object amount) {
    return '$sign$currency$amount';
  }

  @override
  String get navHome => 'मुख्यपृष्ठ';

  @override
  String get navAdd => 'जोडा';

  @override
  String get navList => 'यादी';

  @override
  String get navReports => 'अहवाल';

  @override
  String get navSettings => 'सेटिंग्ज';

  @override
  String get myAnalytics => 'माझे विश्लेषण';

  @override
  String get addAtLeast3Transactions => 'विश्लेषण पाहण्यासाठी किमान ३ व्यवहार जोडा.';

  @override
  String get dailyExpenses => 'दैनंदिन खर्च';

  @override
  String get spendingByCategory => 'श्रेणीनुसार खर्च';

  @override
  String get totalExpenses => 'एकूण खर्च';

  @override
  String get highestSpending => 'सर्वाधिक खर्च';

  @override
  String get biggestChange => 'सर्वात मोठा बदल';

  @override
  String get comingSoon => 'लवकरच येत आहे';

  @override
  String get viewDetailedReport => 'तपशीलवार अहवाल पहा';

  @override
  String onCategory(Object category) {
    return '$category वर';
  }

  @override
  String get monday => 'सोम';

  @override
  String get tuesday => 'मंगळ';

  @override
  String get wednesday => 'बुध';

  @override
  String get thursday => 'गुरु';

  @override
  String get friday => 'शुक्र';

  @override
  String get saturday => 'शनि';

  @override
  String get sunday => 'रवि';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get languageRegion => 'भाषा व प्रदेश';

  @override
  String get language => 'भाषा';

  @override
  String get currency => 'चलन';

  @override
  String get appearance => 'दृश्यरूप';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get largeTextMode => 'मोठा मजकूर मोड';

  @override
  String get dataManagement => 'डेटा व्यवस्थापन';

  @override
  String get autoBackup => 'स्वयंचलित बॅकअप';

  @override
  String get backupFrequency => 'बॅकअप वारंवारता';

  @override
  String get daily => 'दररोज';

  @override
  String get cloudSyncAndSharing => 'क्लाउड सिंक आणि शेअरिंग';

  @override
  String get signInToSync => 'सिंकसाठी साइन इन करा';

  @override
  String get partnerEmailLabel => 'पार्टनर ईमेल (फक्त एकच परवानगी)';

  @override
  String get partnerEmailHint => 'शेअर करण्यासाठी पार्टनरचा ईमेल टाका';

  @override
  String get partnerLockedHint => 'पार्टनर ईमेल लॉक आहे. तुम्ही ते बदलू शकत नाही.';

  @override
  String get onlyOnePartnerInfo => 'तुम्ही फक्त एका पार्टनरसोबत शेअर करू शकता. खाजगी ठेवण्यासाठी रिकामे ठेवा.';

  @override
  String get exportAndShareKhata => 'खाता एक्सपोर्ट व शेअर करा';

  @override
  String get syncFromCloud => 'क्लाउडमधून सिंक करा';

  @override
  String get leaveSharedAccount => 'शेअर केलेला खाते सोडा';

  @override
  String get shareAccount => 'खाते शेअर करा';

  @override
  String get joinAccount => 'खात्यात सामील व्हा';

  @override
  String get noMembersYet => 'अजून सदस्य नाहीत.';

  @override
  String get accountMembers => 'खात्याचे सदस्य';

  @override
  String get shareQrToInvite => 'इतरांना आमंत्रित करण्यासाठी तुमचा QR कोड शेअर करा.';

  @override
  String get youAreAMemberOf => 'आपण या खात्याचे सदस्य आहात:';

  @override
  String get remove => 'काढा';

  @override
  String get memberInfo => 'सदस्य म्हणून, आपण या सामायिक खात्यात व्यवहार पाहू आणि जोडू शकता. फक्त खाते मालक सदस्यांचे व्यवस्थापन करू शकतो.';

  @override
  String get shareKhataAccount => 'खाते शेअर करा';

  @override
  String get shareYourKhataAccount => 'तुमचे खाते शेअर करा';

  @override
  String get letOthersScanQr => 'इतरांना हा QR कोड स्कॅन करू द्या जेणेकरून ते तुमच्या खात्यात सामील होऊ शकतील आणि खर्च शेअर करू शकतील';

  @override
  String get failedToGenerateQr => 'QR कोड तयार करण्यात अयशस्वी';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get qrExpiresIn10Min => 'हा QR कोड 10 मिनिटांत कालबाह्य होईल';

  @override
  String get max5Members => 'कमाल 5 सदस्य तुमच्या खात्यात सामील होऊ शकतात';

  @override
  String get generateNewQr => 'नवीन QR कोड तयार करा';

  @override
  String get scanQrCode => 'QR कोड स्कॅन करा';

  @override
  String get positionQrInFrame => 'QR कोड फ्रेममध्ये ठेवा';

  @override
  String get cameraWillScanAutomatically => 'QR कोड ओळखला गेल्यावर कॅमेरा आपोआप स्कॅन करेल';

  @override
  String get successfullyJoinedSharedAccount => 'सामायिक खात्यात यशस्वीरित्या सामील झाले!';
}
