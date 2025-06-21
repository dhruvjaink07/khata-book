import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:khata/app/main_screen.dart';
import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khata/firebase_options.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('darkMode') ?? false;
  final localeCode = prefs.getString('locale') ?? 'en';
  runApp(MyApp(isDark: isDark, initialLocale: Locale(localeCode)));
}

class MyApp extends StatefulWidget {
  final bool isDark;
  final Locale initialLocale;
  const MyApp({super.key, required this.isDark, required this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDark = widget.isDark;
  late Locale _locale = widget.initialLocale;

  void _toggleDarkMode(bool value) async {
    setState(() => _isDark = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  void _changeLocale(Locale locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final customDarkTheme = ThemeData.dark().copyWith(
      primaryColor: Color(0xff0066FF),
      scaffoldBackgroundColor: const Color(0xFF181A20),
      cardColor: const Color(0xFF23242A),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Color(0xff0066FF),
        background: const Color(0xFF23242A),
        surface: const Color(0xFF23242A),
        surfaceVariant: const Color(0xFF23242A),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
    );

    return MaterialApp(
      title: 'Khata',
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xff0066FF),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        cardColor: Colors.white,
        colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: Color(0xff0066FF),
          background: const Color(0xFFF5F6FA),
          surface: Colors.white,
          surfaceVariant: const Color(0xFFE0E3EB),
          onBackground: Colors.black,
          onSurface: Colors.black,
        ),
      ),
      darkTheme: customDarkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      locale: _locale,
      home: MainScreen(
        onThemeChanged: _toggleDarkMode,
        isDark: _isDark,
        currentLocale: _locale,
        onLocaleChanged: _changeLocale,
      ),
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('gu'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
