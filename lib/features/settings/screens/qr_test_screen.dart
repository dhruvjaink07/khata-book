import 'package:flutter/material.dart';
import 'package:khata/features/settings/widgets/khata_sync_card.dart';
import 'package:khata/auth/auth_service.dart';

class QRTestScreen extends StatefulWidget {
  const QRTestScreen({super.key});

  @override
  State<QRTestScreen> createState() => _QRTestScreenState();
}

class _QRTestScreenState extends State<QRTestScreen> {
  final TextEditingController _partnerEmailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: KhataSyncCard(
          partnerEmailController: _partnerEmailController,
          onExportAndShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export and Share clicked')),
            );
          },
          onSyncFromCloud: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sync from Cloud clicked')),
            );
          },
          isSignedIn: _authService.isSignedIn,
          onSignIn: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sign In clicked')));
          },
          onSignOut: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sign Out clicked')));
          },
          userName: _authService.userName,
          userEmail: _authService.userEmail,
          userPhotoUrl: _authService.userPhotoUrl,
          isPartnerLocked: false,
          signingIn: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _partnerEmailController.dispose();
    super.dispose();
  }
}
