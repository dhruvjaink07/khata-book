import 'package:flutter/material.dart';
import 'package:khata/l10n/app_localizations.dart';

class KhataSyncCard extends StatelessWidget {
  final TextEditingController partnerEmailController;
  final VoidCallback onExportAndShare;
  final VoidCallback onSyncFromCloud;
  final bool isSignedIn;
  final VoidCallback onSignIn;
  final VoidCallback? onSignOut;
  final String? userName;
  final String? userEmail;
  final String? userPhotoUrl;
  final bool isPartnerLocked;

  const KhataSyncCard({
    super.key,
    required this.partnerEmailController,
    required this.onExportAndShare,
    required this.onSyncFromCloud,
    required this.isSignedIn,
    required this.onSignIn,
    required this.isPartnerLocked,
    this.onSignOut,
    this.userName,
    this.userEmail,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.cloudSyncAndSharing,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (!isSignedIn)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: Text(loc.signInToSync),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: onSignIn,
                ),
              ),
            if (isSignedIn) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: userPhotoUrl != null
                    ? CircleAvatar(backgroundImage: NetworkImage(userPhotoUrl!))
                    : const Icon(Icons.account_circle, size: 40),
                title: Text(userName ?? 'User'),
                subtitle: Text(userEmail ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: onSignOut,
                  tooltip: 'Sign Out',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                enabled: !isPartnerLocked,
                controller: partnerEmailController,
                decoration: InputDecoration(
                  labelText: loc.partnerEmailLabel,
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  hintText: loc.partnerEmailHint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                loc.onlyOnePartnerInfo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: Text(loc.exportAndShareKhata),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: isPartnerLocked ? null : onExportAndShare,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.cloud_download),
                label: Text(loc.syncFromCloud),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: onSyncFromCloud,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
