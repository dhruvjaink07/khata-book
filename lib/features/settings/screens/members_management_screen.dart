import 'package:flutter/material.dart';
import 'package:khata/services/member_sharing_service.dart';
import 'package:khata/features/settings/models/sharing_models.dart';
import 'package:khata/features/settings/screens/qr_generator_screen.dart';
import 'package:khata/features/settings/screens/qr_scanner_screen.dart';
import 'package:khata/widgets/user_avatar.dart';
import 'package:khata/widgets/dialog_utils.dart';

class MembersManagementScreen extends StatefulWidget {
  const MembersManagementScreen({super.key});

  @override
  State<MembersManagementScreen> createState() =>
      _MembersManagementScreenState();
}

class _MembersManagementScreenState extends State<MembersManagementScreen> {
  final MemberSharingService _memberService = MemberSharingService();
  SharedAccountInfo? sharedAccountInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSharedAccountInfo();
  }

  Future<void> _loadSharedAccountInfo() async {
    try {
      final info = await _memberService.getSharedAccountInfo();
      setState(() {
        sharedAccountInfo = info;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showRemoveMemberDialog(AccountMember member) async {
    final confirmed = await DialogUtils.showRemoveMemberDialog(
      context: context,
      memberName: member.name,
    );

    if (confirmed == true) {
      try {
        await _memberService.removeMember(member.uid);
        if (mounted) {
          DialogUtils.showSuccessSnackBar(
            context: context,
            message: '${member.name} has been removed',
          );
        }
      } catch (e) {
        if (mounted) {
          DialogUtils.showErrorSnackBar(
            context: context,
            message: 'Failed to remove member: ${e.toString()}',
          );
        }
      }
    }
  }

  Future<void> _showLeaveAccountDialog() async {
    final confirmed = await DialogUtils.showLeaveAccountDialog(
      context: context,
      ownerName: sharedAccountInfo!.ownerName,
    );

    if (confirmed == true) {
      try {
        await _memberService.leaveSharedAccount();
        if (mounted) {
          Navigator.of(context).pop();
          DialogUtils.showSuccessSnackBar(
            context: context,
            message: 'You have left the shared account',
          );
        }
      } catch (e) {
        if (mounted) {
          DialogUtils.showErrorSnackBar(
            context: context,
            message: 'Failed to leave account: ${e.toString()}',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Account Members'),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // If user is a member of another account
    if (sharedAccountInfo != null) {
      return _buildMemberView();
    }

    // If user is an owner
    return _buildOwnerView();
  }

  Widget _buildOwnerView() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Members'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Share Account'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QRGeneratorScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Join Account'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const QRScannerScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Members list
          Expanded(
            child: StreamBuilder<List<AccountMember>>(
              stream: _memberService.getMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final members = snapshot.data ?? [];

                if (members.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_off,
                          size: 64,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No members yet',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Share your QR code to invite others',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: UserAvatar(photoUrl: member.photoUrl),
                        title: Text(member.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.email),
                            Text(
                              'Joined ${_formatDate(member.joinedAt)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.6,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'remove',
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Remove'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'remove') {
                              _showRemoveMemberDialog(member);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberView() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Account'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You are a member of:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        child: Icon(Icons.account_circle),
                      ),
                      title: Text(sharedAccountInfo!.ownerName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sharedAccountInfo!.ownerEmail),
                          Text(
                            'Joined ${_formatDate(sharedAccountInfo!.joinedAt)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                label: const Text(
                  'Leave Shared Account',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: _showLeaveAccountDialog,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'As a member, you can view and add transactions to this shared account. Only the account owner can manage members.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
