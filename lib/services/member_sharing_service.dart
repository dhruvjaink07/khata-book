import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:khata/features/settings/models/sharing_models.dart';

/// Service for managing account sharing and member management
class MemberSharingService {
  static final MemberSharingService _instance =
      MemberSharingService._internal();
  factory MemberSharingService() => _instance;
  MemberSharingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const int maxMembers = 5;

  /// Creates a sharing invitation for the current user
  Future<String> createSharingInvitation() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not signed in');

    final invitationId = _firestore.collection('sharing_invitations').doc().id;

    final invitation = SharingInvitation(
      id: invitationId,
      ownerUid: user.uid,
      ownerName: user.displayName ?? 'User',
      ownerEmail: user.email ?? '',
      ownerPhotoUrl: user.photoURL ?? '',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(
        const Duration(days: 30),
      ), // 30 days instead of 10 minutes
    );

    await _firestore
        .collection('sharing_invitations')
        .doc(invitationId)
        .set(invitation.toFirestore());

    return jsonEncode(invitation.toQRData());
  }

  /// Accepts a sharing invitation from QR code
  Future<bool> acceptSharingInvitation(String invitationId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not signed in');

    // Get invitation details
    final invitationDoc = await _firestore
        .collection('sharing_invitations')
        .doc(invitationId)
        .get();

    if (!invitationDoc.exists) {
      throw Exception('Invitation not found or expired');
    }

    final invitation = SharingInvitation.fromFirestore(invitationDoc);

    // Check if invitation is still valid
    if (!invitation.isActive || invitation.isExpired) {
      throw Exception('Invitation has expired');
    }

    // Check if user is trying to join their own account
    if (invitation.ownerUid == user.uid) {
      throw Exception('You cannot join your own account');
    }

    // Check if owner already has maximum members
    final membersSnapshot = await _firestore
        .collection('shared_accounts')
        .doc(invitation.ownerUid)
        .collection('members')
        .where('isActive', isEqualTo: true)
        .get();

    if (membersSnapshot.docs.length >= maxMembers) {
      throw Exception(
        'Account has reached maximum members limit ($maxMembers)',
      );
    }

    // Check if user is already a member of any account
    final existingMemberDoc = await _firestore
        .collection('member_accounts')
        .doc(user.uid)
        .get();

    if (existingMemberDoc.exists) {
      throw Exception('You are already a member of another shared account');
    } // Add user as member to owner's shared_accounts collection
    final memberData = AccountMember(
      uid: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
      joinedAt: DateTime.now(),
      isActive: true,
    );

    await _firestore
        .collection('shared_accounts')
        .doc(invitation.ownerUid)
        .collection('members')
        .doc(user.uid)
        .set(memberData.toFirestore());

    // Create member_accounts document for the user
    await _firestore.collection('member_accounts').doc(user.uid).set({
      'ownerUid': invitation.ownerUid,
      'ownerName': invitation.ownerName,
      'ownerEmail': invitation.ownerEmail,
      'ownerPhotoUrl': invitation.ownerPhotoUrl,
      'joinedAt': Timestamp.fromDate(DateTime.now()),
    });

    // Update the owner's khata document with the new member
    await _updateKhataSharedWith(invitation.ownerUid);

    // Deactivate the invitation
    await _firestore.collection('sharing_invitations').doc(invitationId).update(
      {'isActive': false},
    );

    return true;
  }

  /// Gets complete shared account information
  Future<SharedAccountInfo?> getSharedAccountInfo() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    // First check if user is a member of another account
    final memberAccountDoc = await _firestore
        .collection('member_accounts')
        .doc(user.uid)
        .get();

    if (memberAccountDoc.exists) {
      final data = memberAccountDoc.data()!;
      return SharedAccountInfo.fromMemberData(data);
    }

    // Then check if user is an owner with members
    final membersSnapshot = await _firestore
        .collection('shared_accounts')
        .doc(user.uid)
        .collection('members')
        .where('isActive', isEqualTo: true)
        .get();

    if (membersSnapshot.docs.isNotEmpty) {
      final members = membersSnapshot.docs
          .map(
            (doc) => AccountMember.fromFirestore(doc, currentUserUid: user.uid),
          )
          .toList();

      return SharedAccountInfo.fromOwnerData(
        ownerUid: user.uid,
        ownerName: user.displayName ?? 'User',
        ownerEmail: user.email ?? '',
        ownerPhotoUrl: user.photoURL ?? '',
        joinedAt: DateTime.now(),
        members: members,
      );
    }

    return null;
  }

  /// Gets all members of the current user's shared account (if owner)
  Future<List<AccountMember>> getAccountMembers() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final membersSnapshot = await _firestore
        .collection('shared_accounts')
        .doc(user.uid)
        .collection('members')
        .where('isActive', isEqualTo: true)
        .get(); // Removed orderBy temporarily

    return membersSnapshot.docs
        .map(
          (doc) => AccountMember.fromFirestore(doc, currentUserUid: user.uid),
        )
        .toList();
  }

  /// Gets a real-time stream of all members (for UI)
  Stream<List<AccountMember>> getMembers() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _firestore
        .collection('shared_accounts')
        .doc(user.uid)
        .collection('members')
        .where('isActive', isEqualTo: true)
        .snapshots() // Removed orderBy temporarily
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AccountMember.fromFirestore(doc, currentUserUid: user.uid),
              )
              .toList(),
        );
  }

  /// Removes a member from the shared account (owner only)
  Future<void> removeMember(String memberUid) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not signed in');

    // Mark member as inactive in owner's collection
    await _firestore
        .collection('shared_accounts')
        .doc(user.uid)
        .collection('members')
        .doc(memberUid)
        .update({'isActive': false});

    // Remove member's account reference
    await _firestore.collection('member_accounts').doc(memberUid).delete();

    // Update the owner's khata document with the updated member list
    await _updateKhataSharedWith(user.uid);
  }

  /// Leaves a shared account (member only)
  Future<void> leaveSharedAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not signed in');

    final memberAccountDoc = await _firestore
        .collection('member_accounts')
        .doc(user.uid)
        .get();

    if (!memberAccountDoc.exists) {
      throw Exception('You are not a member of any shared account');
    }

    final data = memberAccountDoc.data()!;
    final ownerUid = data['ownerUid'];

    // Mark member as inactive in owner's account
    await _firestore
        .collection('shared_accounts')
        .doc(ownerUid)
        .collection('members')
        .doc(user.uid)
        .update({'isActive': false});

    // Remove member account reference
    await _firestore.collection('member_accounts').doc(user.uid).delete();

    // Update the owner's khata document with the updated member list
    await _updateKhataSharedWith(ownerUid);
  }

  /// Cleans up expired invitations
  Future<void> cleanupExpiredInvitations() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiredInvitations = await _firestore
        .collection('sharing_invitations')
        .where('expiresAt', isLessThan: now)
        .where('isActive', isEqualTo: true)
        .get();

    for (final doc in expiredInvitations.docs) {
      await doc.reference.update({'isActive': false});
    }
  }

  /// Streams changes to shared account info
  Stream<SharedAccountInfo?> watchSharedAccountInfo() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return Stream.fromFuture(getSharedAccountInfo()).asyncExpand((initialInfo) {
      if (initialInfo?.isOwner == true) {
        // Watch for changes in members if user is owner
        return _firestore
            .collection('shared_accounts')
            .doc(user.uid)
            .collection('members')
            .where('isActive', isEqualTo: true)
            .snapshots()
            .asyncMap((_) => getSharedAccountInfo());
      } else {
        // Watch for changes in member account if user is member
        return _firestore
            .collection('member_accounts')
            .doc(user.uid)
            .snapshots()
            .asyncMap((_) => getSharedAccountInfo());
      }
    });
  }

  /// Updates the sharedWith list in the owner's khata document
  Future<void> _updateKhataSharedWith(String ownerUid) async {
    try {
      // Get owner's email from the member_accounts collection or shared_accounts
      String? ownerEmail;

      // Try to get owner email from any member's record
      final membersSnapshot = await _firestore
          .collection('shared_accounts')
          .doc(ownerUid)
          .collection('members')
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (membersSnapshot.docs.isNotEmpty) {
        // Get owner email from member data (stored when member joined)
        final firstMemberDoc = await _firestore
            .collection('member_accounts')
            .doc(membersSnapshot.docs.first.id)
            .get();
        if (firstMemberDoc.exists) {
          ownerEmail = firstMemberDoc.data()!['ownerEmail'] as String?;
        }
      }

      // Fallback: try to get from current user if they are the owner
      if (ownerEmail == null) {
        final currentUser = _auth.currentUser;
        if (currentUser != null && currentUser.uid == ownerUid) {
          ownerEmail = currentUser.email;
        }
      }

      if (ownerEmail == null) {
        print('❌ Could not find owner email for UID: $ownerUid');
        return;
      }

      // Get all active members
      final allMembersSnapshot = await _firestore
          .collection('shared_accounts')
          .doc(ownerUid)
          .collection('members')
          .where('isActive', isEqualTo: true)
          .get();

      // Build the sharedWith list
      final List<String> sharedWith = [];
      for (final memberDoc in allMembersSnapshot.docs) {
        final memberData = memberDoc.data();
        final memberEmail = memberData['email'] as String?;
        if (memberEmail != null && memberEmail.isNotEmpty) {
          sharedWith.add(memberEmail);
        }
      }

      // Update the khata document using OWNER'S EMAIL as document ID
      await _firestore.collection('khatas').doc(ownerEmail).update({
        'sharedWith': sharedWith,
        'lastUpdated': DateTime.now().toUtc().toIso8601String(),
      });

      print('✅ Updated sharedWith list for owner $ownerEmail: $sharedWith');
    } catch (e) {
      print('❌ Error updating sharedWith list: $e');
    }
  }
}
