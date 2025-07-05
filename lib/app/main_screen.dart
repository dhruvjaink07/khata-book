import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khata/auth/auth_service.dart';
import 'package:khata/features/add_expense/add_expense_screen.dart';
import 'package:khata/features/home/home_screen.dart';
import 'package:khata/l10n/app_localizations.dart';
import '../features/reports/analytics_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/transactions/transaction_list_screen.dart';
import 'package:khata/services/khata_sync_service.dart';
import 'package:khata/services/member_sharing_service.dart';

class MainScreen extends StatefulWidget {
  final ValueChanged<bool>? onThemeChanged;
  final bool isDark;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const MainScreen({
    super.key,
    this.onThemeChanged,
    this.isDark = false,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreen = 0;
  late List<Widget> _screens;

  StreamSubscription? _khataSub;
  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      AddExpenseScreen(),
      TransactionListScreen(),
      AnalyticsScreen(),
      SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        isDark: widget.isDark,
        currentLocale: widget.currentLocale,
        onLocaleChanged: widget.onLocaleChanged,
      ),
    ];
    _startKhataListener();

    // Perform initial sync if user is already signed in
    _performInitialSyncIfSignedIn();

    // Start real-time sync for shared accounts
    _startRealtimeSync();
  }

  void _startRealtimeSync() {
    final authService = AuthService();
    if (authService.isSignedIn) {
      KhataSyncService().startRealTimeSync();
    }
  }

  void _startKhataListener() {
    _khataSub?.cancel();
    final authService = AuthService();
    if (authService.isSignedIn) {
      _khataSub = KhataSyncService().listenToKhataChanges().listen((
        hasChanges,
      ) {
        if (hasChanges) {
          setState(() {}); // Triggers UI update when data changes
        }
      });
    }
  }

  Future<void> _performInitialSyncIfSignedIn() async {
    final authService = AuthService();
    if (authService.isSignedIn) {
      try {
        // Clean up any data inconsistencies first
        await MemberSharingService().cleanupDataInconsistencies();

        // Sync from cloud first to get shared data
        await KhataSyncService().syncFromCloud();
        // Then sync local data to cloud
        await KhataSyncService().syncToCloud();
        print('Initial sync completed successfully on app startup');
      } catch (e) {
        print('Initial sync failed on app startup: $e');
        // Fail silently for better UX
      }
    }
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update SettingsScreen with new locale if changed
    _screens[4] = SettingsScreen(
      onThemeChanged: widget.onThemeChanged,
      isDark: widget.isDark,
      currentLocale: widget.currentLocale,
      onLocaleChanged: widget.onLocaleChanged,
    );
  }

  @override
  void dispose() {
    _khataSub?.cancel();
    KhataSyncService().stopRealTimeSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_selectedScreen],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreen,
        onTap: (index) {
          setState(() {
            _selectedScreen = index;
          });
        },
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        backgroundColor: colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: loc.navHome,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: loc.navAdd),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: loc.navList),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: loc.navReports,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: loc.navSettings,
          ),
        ],
      ),
    );
  }
}
