import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for sharing invitations
class SharingInvitation {
  final String id;
  final String ownerUid;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhotoUrl;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isActive;

  SharingInvitation({
    required this.id,
    required this.ownerUid,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhotoUrl,
    required this.createdAt,
    required this.expiresAt,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhotoUrl': ownerPhotoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isActive': isActive,
    };
  }

  static SharingInvitation fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SharingInvitation(
      id: data['id'] ?? '',
      ownerUid: data['ownerUid'] ?? '',
      ownerName: data['ownerName'] ?? '',
      ownerEmail: data['ownerEmail'] ?? '',
      ownerPhotoUrl: data['ownerPhotoUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toQRData() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'type': 'khata_invitation',
    };
  }
}

/// Model for account members
class AccountMember {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime joinedAt;
  final bool isActive;

  AccountMember({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.joinedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'isActive': isActive,
    };
  }

  static AccountMember fromFirestore(
    DocumentSnapshot doc, {
    required String currentUserUid,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return AccountMember(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }
}

/// Model for shared account information
class SharedAccountInfo {
  final String ownerUid;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhotoUrl;
  final DateTime joinedAt;
  final List<AccountMember> members;
  final bool isOwner;

  SharedAccountInfo({
    required this.ownerUid,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhotoUrl,
    required this.joinedAt,
    required this.members,
    required this.isOwner,
  });

  static SharedAccountInfo fromMemberData(Map<String, dynamic> data) {
    return SharedAccountInfo(
      ownerUid: data['ownerUid'] ?? '',
      ownerName: data['ownerName'] ?? '',
      ownerEmail: data['ownerEmail'] ?? '',
      ownerPhotoUrl: data['ownerPhotoUrl'] ?? '',
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      members: [],
      isOwner: false,
    );
  }

  static SharedAccountInfo fromOwnerData({
    required String ownerUid,
    required String ownerName,
    required String ownerEmail,
    required String ownerPhotoUrl,
    required DateTime joinedAt,
    required List<AccountMember> members,
  }) {
    return SharedAccountInfo(
      ownerUid: ownerUid,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ownerPhotoUrl: ownerPhotoUrl,
      joinedAt: joinedAt,
      members: members,
      isOwner: true,
    );
  }
}
