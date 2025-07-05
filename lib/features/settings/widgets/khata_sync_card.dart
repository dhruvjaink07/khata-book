import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:khata/services/member_sharing_service.dart';
import 'package:khata/services/khata_sync_service.dart';
import 'package:khata/l10n/app_localizations.dart';
import 'package:khata/widgets/user_avatar.dart';
import 'package:khata/widgets/dialog_utils.dart';
import 'package:khata/features/settings/models/sharing_models.dart';

class KhataSyncCard extends StatefulWidget {
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
  final bool signingIn;

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
    this.userPhotoUrl,
    this.userEmail,
    this.signingIn = false,
  });

  @override
  State<KhataSyncCard> createState() => _KhataSyncCardState();
}

class _KhataSyncCardState extends State<KhataSyncCard> {
  SharedAccountInfo? sharedAccountInfo;
  bool isLoadingSharedInfo = true;

  @override
  void initState() {
    super.initState();
    if (widget.isSignedIn) {
      _loadSharedAccountInfo();
    }
  }

  @override
  void didUpdateWidget(KhataSyncCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSignedIn != oldWidget.isSignedIn && widget.isSignedIn) {
      _loadSharedAccountInfo();
    }
  }

  Future<void> _loadSharedAccountInfo() async {
    if (!widget.isSignedIn) return;

    try {
      final info = await MemberSharingService().getSharedAccountInfo();
      setState(() {
        sharedAccountInfo = info;
        isLoadingSharedInfo = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSharedInfo = false;
      });
    }
  }

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

            if (!widget.isSignedIn)
              _buildSignInSection(context, loc, colorScheme)
            else ...[
              _buildUserSection(context, colorScheme),
              const SizedBox(height: 16),
              if (isLoadingSharedInfo)
                const Center(child: CircularProgressIndicator())
              else if (sharedAccountInfo != null && !sharedAccountInfo!.isOwner)
                _buildMemberSection(context, colorScheme)
              else
                _buildOwnerSection(context, colorScheme),
              const SizedBox(height: 16),
              _buildSyncButtons(context, loc),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSignInSection(
    BuildContext context,
    AppLocalizations loc,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.cloud_off,
            size: 48,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Sign in to sync your data and share accounts',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(loc.signInToSync),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: widget.signingIn ? null : widget.onSignIn,
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: UserAvatar(photoUrl: widget.userPhotoUrl, radius: 20),
        title: Text(widget.userName ?? 'User'),
        subtitle: Text(widget.userEmail ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: widget.onSignOut,
          tooltip: 'Sign Out',
        ),
      ),
    );
  }

  Widget _buildMemberSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.secondary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group_add, color: colorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'You\'re a Member',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'You have access to ${sharedAccountInfo!.ownerName}\'s shared account. You can view and add transactions.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                UserAvatar(
                  photoUrl: sharedAccountInfo!.ownerPhotoUrl,
                  radius: 16,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Owner: ${sharedAccountInfo!.ownerName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        sharedAccountInfo!.ownerEmail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              label: const Text(
                'Leave Account',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () => _leaveSharedAccount(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Share Your Account (Up to 5 members)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Share your Khata account with family and friends using QR codes. Everyone can add transactions and view shared expenses.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Share QR'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: () => _showQRGeneratorDialog(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Join Other'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: () => _showQRScannerDialog(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<AccountMember>>(
            stream: MemberSharingService().getMembers(),
            builder: (context, snapshot) {
              final members = snapshot.data ?? [];
              if (members.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No members yet. Share your QR code to invite others.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${members.length}/5 Members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...members
                      .take(3)
                      .map(
                        (member) => Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              UserAvatar(photoUrl: member.photoUrl),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  member.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 16,
                                ),
                                color: Colors.red,
                                onPressed: () => _removeMember(context, member),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (members.length > 3)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '... and ${members.length - 3} more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSyncButtons(BuildContext context, AppLocalizations loc) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.cloud_upload),
          label: Text(loc.exportAndShareKhata),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: widget.onExportAndShare,
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.cloud_download),
          label: Text(loc.syncFromCloud),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: widget.onSyncFromCloud,
        ),
      ],
    );
  }

  Future<void> _showQRGeneratorDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const QRGeneratorDialog(),
    );
  }

  Future<void> _showQRScannerDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const QRScannerDialog(),
    );
    if (result == true && context.mounted) {
      DialogUtils.showSuccessSnackBar(
        context: context,
        message: 'Successfully joined the shared account!',
      );
      // Refresh the shared account info
      _loadSharedAccountInfo();

      // Trigger sync to get shared data immediately
      _performSyncAfterJoining(context);
    }
  }

  Future<void> _performSyncAfterJoining(BuildContext context) async {
    try {
      // Show loading message
      DialogUtils.showInfoSnackBar(
        context: context,
        message: 'Syncing shared data...',
      );

      // Sync from cloud first to get shared data
      final success = await KhataSyncService().syncFromCloud();
      if (success) {
        // Then sync local data to cloud
        await KhataSyncService().syncToCloud();

        DialogUtils.showSuccessSnackBar(
          context: context,
          message: 'Shared data synced successfully!',
        );
      }
    } catch (e) {
      print('Sync after joining failed: $e');
      DialogUtils.showErrorSnackBar(
        context: context,
        message: 'Sync completed with some issues: ${e.toString()}',
      );
    }
  }

  Future<void> _removeMember(BuildContext context, AccountMember member) async {
    final confirmed = await DialogUtils.showRemoveMemberDialog(
      context: context,
      memberName: member.name,
    );

    if (confirmed == true) {
      try {
        await MemberSharingService().removeMember(member.uid);
        if (context.mounted) {
          DialogUtils.showSuccessSnackBar(
            context: context,
            message: '${member.name} removed',
          );
        }
      } catch (e) {
        if (context.mounted) {
          DialogUtils.showErrorSnackBar(
            context: context,
            message: 'Failed to remove: $e',
          );
        }
      }
    }
  }

  Future<void> _leaveSharedAccount(BuildContext context) async {
    final confirmed = await DialogUtils.showLeaveAccountDialog(
      context: context,
      ownerName: sharedAccountInfo!.ownerName,
    );

    if (confirmed == true) {
      try {
        await MemberSharingService().leaveSharedAccount();
        if (context.mounted) {
          DialogUtils.showSuccessSnackBar(
            context: context,
            message: 'You have left the shared account',
          );
          // Refresh the state
          _loadSharedAccountInfo();
        }
      } catch (e) {
        if (context.mounted) {
          DialogUtils.showErrorSnackBar(
            context: context,
            message: 'Failed to leave account: $e',
          );
        }
      }
    }
  }
}

// QR Generator Dialog
class QRGeneratorDialog extends StatefulWidget {
  const QRGeneratorDialog({super.key});

  @override
  State<QRGeneratorDialog> createState() => _QRGeneratorDialogState();
}

class _QRGeneratorDialogState extends State<QRGeneratorDialog> {
  String? qrData;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _generateQR();
  }

  Future<void> _generateQR() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await MemberSharingService().createSharingInvitation();
      setState(() {
        qrData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.qr_code, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Share Account',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to generate QR code',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _generateQR,
                    child: const Text('Try Again'),
                  ),
                ],
              )
            else if (qrData != null)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: QrImageView(
                      data: qrData!,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'QR code expires in 30 days\nMax 5 members allowed',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _generateQR,
                    child: const Text('Generate New QR'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// QR Scanner Dialog
class QRScannerDialog extends StatefulWidget {
  const QRScannerDialog({super.key});

  @override
  State<QRScannerDialog> createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        height: 500,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.flash_on),
                    onPressed: () => cameraController.toggleTorch(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Scanner
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  ),
                  if (isProcessing)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            // Error display
            if (error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  error!,
                  style: TextStyle(color: colorScheme.onErrorContainer),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing || !mounted) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    if (!mounted) return;
    setState(() {
      isProcessing = true;
      error = null;
    });

    try {
      // Parse the QR data JSON to extract the invitation ID
      final qrData = jsonDecode(barcode.rawValue!);

      // Validate QR data format
      if (qrData['type'] != 'khata_invitation' || qrData['id'] == null) {
        throw Exception('Invalid QR code format');
      }

      final invitationId = qrData['id'] as String;

      final success = await MemberSharingService().acceptSharingInvitation(
        invitationId,
      );

      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        isProcessing = false;
      });

      // Clear error after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            error = null;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
