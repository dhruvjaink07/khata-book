// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मेरा खाता';

  @override
  String monthYear(Object month, Object year) {
    return '$month $year';
  }

  @override
  String get totalBalance => 'कुल शेष';

  @override
  String balanceChange(Object percentage) {
    return 'इस महीने $percentage%';
  }

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get income => 'आय';

  @override
  String vsLastMonth(Object percentage) {
    return 'पिछले महीने की तुलना में $percentage%';
  }

  @override
  String get expenseCategories => 'व्यय श्रेणियाँ';

  @override
  String get recentTransactions => 'हाल की लेन-देन';

  @override
  String get noTransactions => 'अभी तक कोई लेन-देन नहीं।';

  @override
  String get noExpenseData => 'इस महीने के लिए कोई व्यय डेटा नहीं।';

  @override
  String get january => 'जनवरी';

  @override
  String get february => 'फरवरी';

  @override
  String get march => 'मार्च';

  @override
  String get april => 'अप्रैल';

  @override
  String get may => 'मई';

  @override
  String get june => 'जून';

  @override
  String get july => 'जुलाई';

  @override
  String get august => 'अगस्त';

  @override
  String get september => 'सितंबर';

  @override
  String get october => 'अक्टूबर';

  @override
  String get november => 'नवंबर';

  @override
  String get december => 'दिसंबर';

  @override
  String get housing => 'आवास';

  @override
  String get food => 'भोजन';

  @override
  String get transport => 'परिवहन';

  @override
  String get shopping => 'खरीदारी';

  @override
  String get others => 'अन्य';

  @override
  String get debit => 'डेबिट';

  @override
  String get credit => 'क्रेडिट';

  @override
  String get amount => 'राशि';

  @override
  String get percentChange => 'प्रतिशत परिवर्तन';

  @override
  String get positiveChange => 'वृद्धि';

  @override
  String get negativeChange => 'कमी';

  @override
  String get category => 'श्रेणी';

  @override
  String get percentage => 'प्रतिशत';

  @override
  String get noData => 'कोई डेटा उपलब्ध नहीं।';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'एक त्रुटि हुई।';

  @override
  String get addTransaction => 'लेन-देन जोड़ें';

  @override
  String get expense => 'व्यय';

  @override
  String get incomeType => 'आय';

  @override
  String get amountLabel => 'राशि';

  @override
  String get amountHint => '0.00';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get categoryHint => 'श्रेणी';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get notesLabel => 'नोट्स (वैकल्पिक)';

  @override
  String get notesHint => 'यहाँ नोट्स जोड़ें...';

  @override
  String get save => 'सहेजें';

  @override
  String get pleaseSelectCategory => 'कृपया एक श्रेणी चुनें';

  @override
  String get pleaseEnterValidAmount => 'कृपया मान्य राशि दर्ज करें';

  @override
  String get transactionAdded => 'लेन-देन जोड़ा गया!';

  @override
  String get foodAndDining => 'भोजन और भोजनालय';

  @override
  String get groceries => 'किराना';

  @override
  String get healthAndFitness => 'स्वास्थ्य और फिटनेस';

  @override
  String get entertainment => 'मनोरंजन';

  @override
  String get utilities => 'यूटिलिटीज़';

  @override
  String get rent => 'किराया';

  @override
  String get travel => 'यात्रा';

  @override
  String get education => 'शिक्षा';

  @override
  String get subscriptions => 'सदस्यता';

  @override
  String get insurance => 'बीमा';

  @override
  String get personalCare => 'व्यक्तिगत देखभाल';

  @override
  String get giftsAndDonations => 'उपहार और दान';

  @override
  String get othersCategory => 'अन्य';

  @override
  String get salary => 'वेतन';

  @override
  String get freelance => 'फ्रीलांस';

  @override
  String get interest => 'ब्याज';

  @override
  String get investments => 'निवेश';

  @override
  String get gifts => 'उपहार';

  @override
  String get rentalIncome => 'किराया आय';

  @override
  String get refunds => 'रिफंड';

  @override
  String get otherIncome => 'अन्य आय';

  @override
  String get searchTransactions => 'लेन-देन खोजें...';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterThisMonth => 'इस महीने';

  @override
  String get filterGroceries => 'किराना';

  @override
  String get filterShopping => 'खरीदारी';

  @override
  String get filterSalary => 'वेतन';

  @override
  String get filterRent => 'किराया';

  @override
  String get filterTravel => 'यात्रा';

  @override
  String get filterOthers => 'अन्य';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get transaction => 'लेन-देन';

  @override
  String get noTransactionsFound => 'कोई लेन-देन नहीं मिला।';

  @override
  String amountCurrency(Object sign, Object currency, Object amount) {
    return '$sign$currency$amount';
  }

  @override
  String get navHome => 'होम';

  @override
  String get navAdd => 'जोड़ें';

  @override
  String get navList => 'सूची';

  @override
  String get navReports => 'रिपोर्ट्स';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get myAnalytics => 'मेरी एनालिटिक्स';

  @override
  String get addAtLeast3Transactions => 'एनालिटिक्स देखने के लिए कम से कम 3 लेन-देन जोड़ें।';

  @override
  String get dailyExpenses => 'दैनिक खर्च';

  @override
  String get spendingByCategory => 'श्रेणी अनुसार खर्च';

  @override
  String get totalExpenses => 'कुल खर्च';

  @override
  String get highestSpending => 'सबसे अधिक खर्च';

  @override
  String get biggestChange => 'सबसे बड़ा बदलाव';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get viewDetailedReport => 'विस्तृत रिपोर्ट देखें';

  @override
  String onCategory(Object category) {
    return '$category पर';
  }

  @override
  String get monday => 'सोम';

  @override
  String get tuesday => 'मंगल';

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
  String get settings => 'सेटिंग्स';

  @override
  String get languageRegion => 'भाषा और क्षेत्र';

  @override
  String get language => 'भाषा';

  @override
  String get currency => 'मुद्रा';

  @override
  String get appearance => 'रूप';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get largeTextMode => 'बड़ा टेक्स्ट मोड';

  @override
  String get dataManagement => 'डेटा प्रबंधन';

  @override
  String get autoBackup => 'स्वचालित बैकअप';

  @override
  String get backupFrequency => 'बैकअप आवृत्ति';

  @override
  String get daily => 'दैनिक';

  @override
  String get cloudSyncAndSharing => 'क्लाउड सिंक और शेयरिंग';

  @override
  String get signInToSync => 'सिंक के लिए साइन इन करें';

  @override
  String get partnerEmailLabel => 'पार्टनर ईमेल (केवल एक की अनुमति)';

  @override
  String get partnerEmailHint => 'शेयर करने के लिए पार्टनर का ईमेल दर्ज करें';

  @override
  String get partnerLockedHint => 'पार्टनर ईमेल लॉक है। आप इसे बदल नहीं सकते।';

  @override
  String get onlyOnePartnerInfo => 'आप केवल एक पार्टनर के साथ शेयर कर सकते हैं। निजी रखने के लिए खाली छोड़ें।';

  @override
  String get exportAndShareKhata => 'खाता एक्सपोर्ट और शेयर करें';

  @override
  String get syncFromCloud => 'क्लाउड से सिंक करें';

  @override
  String get leaveSharedAccount => 'शेयर किया गया खाता छोड़ें';

  @override
  String get shareAccount => 'खाता शेयर करें';

  @override
  String get joinAccount => 'खाते में शामिल हों';

  @override
  String get noMembersYet => 'अभी कोई सदस्य नहीं हैं।';

  @override
  String get accountMembers => 'खाते के सदस्य';

  @override
  String get shareQrToInvite => 'अन्य लोगों को आमंत्रित करने के लिए अपना QR कोड साझा करें।';

  @override
  String get youAreAMemberOf => 'आप इस खाते के सदस्य हैं:';

  @override
  String get remove => 'हटाएं';

  @override
  String get memberInfo => 'सदस्य के रूप में, आप इस साझा खाते में लेन-देन देख और जोड़ सकते हैं। केवल खाता स्वामी ही सदस्यों का प्रबंधन कर सकता है।';

  @override
  String get shareKhataAccount => 'खाता शेयर करें';

  @override
  String get shareYourKhataAccount => 'अपना खाता शेयर करें';

  @override
  String get letOthersScanQr => 'दूसरों को इस QR कोड को स्कैन करने दें ताकि वे आपके खाते में शामिल हो सकें और खर्च साझा कर सकें';

  @override
  String get failedToGenerateQr => 'QR कोड जनरेट करने में विफल';

  @override
  String get tryAgain => 'फिर से प्रयास करें';

  @override
  String get qrExpiresIn10Min => 'यह QR कोड 10 मिनट में समाप्त हो जाएगा';

  @override
  String get max5Members => 'अधिकतम 5 सदस्य आपके खाते में शामिल हो सकते हैं';

  @override
  String get generateNewQr => 'नया QR कोड जनरेट करें';

  @override
  String get scanQrCode => 'QR कोड स्कैन करें';

  @override
  String get positionQrInFrame => 'QR कोड को फ्रेम के भीतर रखें';

  @override
  String get cameraWillScanAutomatically => 'कैमरा अपने आप स्कैन करेगा जब QR कोड पहचाना जाएगा';

  @override
  String get successfullyJoinedSharedAccount => 'साझा खाते में सफलतापूर्वक शामिल हो गए!';
}
