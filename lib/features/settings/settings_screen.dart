import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khata/auth/auth_service.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'widgets/language_card.dart';
import 'widgets/appearance_card.dart';
import 'widgets/data_management_card.dart';
import 'widgets/khata_sync_card.dart';
import 'service/settings_service.dart';
import 'package:khata/services/khata_sync_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<bool>? onThemeChanged;
  final bool isDark;
  final Locale? currentLocale;
  final ValueChanged<Locale>? onLocaleChanged;
  const SettingsScreen({
    super.key,
    this.onThemeChanged,
    this.isDark = false,
    this.currentLocale,
    this.onLocaleChanged,
  });
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _signingIn = false;
  late bool darkMode;
  bool largeText = false;
  bool autoBackup = false;
  late Locale _selectedLocale;
  final SettingsService service = SettingsService();
  final TextEditingController _partnerEmailController = TextEditingController();
  StreamSubscription? _khataSub;
  StreamSubscription? _connectivitySub;
  String? _currentPartnerEmail;

  @override
  void initState() {
    super.initState();
    darkMode = widget.isDark;
    _selectedLocale = widget.currentLocale ?? const Locale('en');
    _startKhataListener();
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
        KhataSyncService().syncToCloud();
        KhataSyncService().syncFromCloud();
      }
    });
  }

  void _startKhataListener() {
    _khataSub?.cancel();
    final authService = AuthService();
    final userEmail = authService.userEmail;
    if (userEmail != null) {
      _khataSub = KhataSyncService().listenToKhataChanges(userEmail).listen((
        _,
      ) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _khataSub?.cancel();
    _partnerEmailController.dispose();
    _connectivitySub?.cancel();
    super.dispose();
  }

  Future<void> _handleSignIn(BuildContext context) async {
    if (_signingIn) return; // Prevent double sign-in
    setState(() => _signingIn = true);
    final authService = AuthService();
    final result = await authService.signInWithGoogle();
    setState(() => _signingIn = false);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as ${authService.userEmail}')),
      );
      _startKhataListener();

      // Trigger automatic sync when user signs in
      _performInitialSync(context);

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in cancelled or failed')),
      );
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await AuthService().signOut();
    setState(() {});
  }

  Future<void> _performInitialSync(BuildContext context) async {
    try {
      // Show loading message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syncing your data...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Sync from cloud first to get shared data
      final success = await KhataSyncService().syncFromCloud();
      if (success) {
        // Then sync local data to cloud
        await KhataSyncService().syncToCloud();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Sync failed, but don't block the user
      print('Initial sync failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync completed with some issues: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleExportAndShare(BuildContext context) async {
    final authService = AuthService();
    if (!authService.isSignedIn) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in first!')));
      return;
    }
    final partnerEmail = _partnerEmailController.text.trim();
    try {
      await KhataSyncService().syncToCloud(partnerEmail: partnerEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            partnerEmail.isNotEmpty
                ? 'Khata shared with $partnerEmail!'
                : 'Khata exported to Firestore!',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _handleSyncFromFirestore(BuildContext context) async {
    final authService = AuthService();
    if (!authService.isSignedIn) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in first!')));
      return;
    }
    try {
      final success = await KhataSyncService().syncFromCloud();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transactions synced from Firestore!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No shared khata found or no transactions.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final sectionLabel = colorScheme.onSurface.withOpacity(0.6);
    final authService = AuthService();

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Text(
              loc.settings,
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              loc.languageRegion,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: sectionLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            LanguageCard(
              selectedLocale: _selectedLocale,
              onLocaleChanged: (locale) {
                setState(() => _selectedLocale = locale);
                widget.onLocaleChanged?.call(locale);
              },
              service: service,
            ),
            const SizedBox(height: 28),
            Text(
              loc.appearance,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: sectionLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            AppearanceCard(
              darkMode: darkMode,
              onThemeChanged: (v) {
                setState(() => darkMode = v);
                widget.onThemeChanged?.call(v);
              },
              largeText: largeText,
              onLargeTextChanged: (v) {
                setState(() => largeText = v);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Under Development: Large Text Mode')),
                );
              },
            ),
            const SizedBox(height: 28),
            Text(
              loc.dataManagement,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: sectionLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DataManagementCard(
              autoBackup: autoBackup,
              onAutoBackupChanged: (v) => setState(() => autoBackup = v),
            ),
            const SizedBox(height: 28),
            KhataSyncCard(
              partnerEmailController: _partnerEmailController,
              onExportAndShare: () => _handleExportAndShare(context),
              onSyncFromCloud: () => _handleSyncFromFirestore(context),
              isSignedIn: authService.isSignedIn,
              onSignIn: () => _handleSignIn(context),
              onSignOut: authService.isSignedIn
                  ? () => _handleSignOut(context)
                  : null,
              userName: authService.userName,
              userEmail: authService.userEmail,
              userPhotoUrl: authService.userPhotoUrl,
              isPartnerLocked:
                  _currentPartnerEmail != null &&
                  _currentPartnerEmail!.isNotEmpty &&
                  _currentPartnerEmail != authService.userEmail,
              signingIn: _signingIn,
            ),
          ],
        ),
      ),
    );
  }
}
