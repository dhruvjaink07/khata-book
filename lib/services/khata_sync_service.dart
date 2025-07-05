import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:hive/hive.dart';
import 'package:khata/auth/auth_service.dart';
import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class KhataSyncService {
  static final KhataSyncService _instance = KhataSyncService._internal();
  factory KhataSyncService() => _instance;
  KhataSyncService._internal();

  StreamSubscription? _syncSubscription;
  Timer? _autoSyncTimer;

  /// Syncs all local transactions to Firestore for the current user.
  /// For shared accounts, everyone syncs to the owner's document.
  Future<void> syncToCloud({String? partnerEmail}) async {
    if (!await _isNetworkAvailable()) {
      throw Exception(
        'No internet connection. Please connect to the internet to sync.',
      );
    }
    final authService = AuthService();
    if (!authService.isSignedIn) return;
    final userEmail = authService.userEmail!;
    final userUid = authService.currentUser!.uid;
    print(
      '🔄 SYNC TO CLOUD: Starting sync for user: $userEmail (UID: $userUid)',
    );

    // Determine which document to sync to and get ownership info
    String targetDocumentId;
    String ownerUid;
    String ownerEmail;
    bool isUserOwner = true;

    // Check if user is a member of a shared account
    final memberDoc = await FirebaseFirestore.instance
        .collection('member_accounts')
        .doc(userUid)
        .get();

    if (memberDoc.exists) {
      // User is a member - sync to owner's document using OWNER'S EMAIL
      final memberData = memberDoc.data()!;
      ownerUid = memberData['ownerUid'] as String;
      ownerEmail = memberData['ownerEmail'] as String;
      targetDocumentId = ownerEmail; // Use owner's email as document ID
      isUserOwner = false;
      print(
        '🔄 SYNC TO CLOUD: User is a member, syncing to owner email: $ownerEmail',
      );
    } else {
      // User is owner - sync to own document using OWN EMAIL
      ownerUid = userUid;
      ownerEmail = userEmail;
      targetDocumentId = userEmail; // Use own email as document ID
      print(
        '🔄 SYNC TO CLOUD: User is owner, syncing to own email: $userEmail',
      );
    }

    final khataDoc = FirebaseFirestore.instance
        .collection('khatas')
        .doc(targetDocumentId);

    final box = Hive.box<Transaction>('transactions');
    final localTxns = await Future.wait(
      box.values.map((t) => t.toEncryptedJson()),
    );

    print(
      '🔄 SYNC TO CLOUD: Found ${localTxns.length} local transactions to sync to document: $targetDocumentId',
    );

    // Get current data to merge with existing transactions
    final currentDoc = await khataDoc.get();
    List<dynamic> existingTxns = [];

    if (currentDoc.exists) {
      final currentData = currentDoc.data() as Map<String, dynamic>;
      existingTxns = currentData['transactions'] ?? [];
    }

    // Merge transactions (avoid duplicates by ID)
    final Map<String, dynamic> txnMap = {};

    // Add existing transactions first
    for (final txn in existingTxns) {
      if (txn is Map<String, dynamic> && txn.containsKey('id')) {
        txnMap[txn['id']] = txn;
      }
    }

    // Add/update local transactions
    for (final txn in localTxns) {
      if (txn.containsKey('id')) {
        txnMap[txn['id']] = txn;
      }
    }

    final mergedTxns = txnMap.values.toList();

    // Build shared with list - only if user is owner
    List<String> sharedWith = [];
    if (isUserOwner) {
      // Get list of active members
      final membersQuery = await FirebaseFirestore.instance
          .collection('shared_accounts')
          .doc(userUid)
          .collection('members')
          .where('isActive', isEqualTo: true)
          .get();

      for (final memberDoc in membersQuery.docs) {
        final memberData = memberDoc.data();
        final memberEmail = memberData['email'] as String?;
        if (memberEmail != null && memberEmail.isNotEmpty) {
          sharedWith.add(memberEmail);
        }
      }

      // Add legacy partnerEmail if provided (for backward compatibility)
      if (partnerEmail != null &&
          partnerEmail.isNotEmpty &&
          !sharedWith.contains(partnerEmail)) {
        sharedWith.add(partnerEmail);
      }
    }

    // Update the khata document
    await khataDoc.set({
      'ownerEmail': ownerEmail,
      'ownerUid': ownerUid,
      'sharedWith': sharedWith,
      'transactions': mergedTxns,
      'lastSynced': DateTime.now().toUtc().toIso8601String(),
      'lastSyncedBy': userEmail,
    }, SetOptions(merge: true));

    print(
      '✅ SYNC TO CLOUD: Successfully synced ${mergedTxns.length} total transactions (${localTxns.length} from local)',
    );
  }

  /// Fetches and imports transactions from Firestore for the current user.
  /// For shared accounts, everyone syncs from the owner's document.
  Future<bool> syncFromCloud() async {
    if (!await _isNetworkAvailable()) {
      throw Exception(
        'No internet connection. Please connect to the internet to sync.',
      );
    }
    final authService = AuthService();
    if (!authService.isSignedIn) return false;
    final userEmail = authService.userEmail!;
    final userUid = authService.currentUser!.uid;
    print(
      '🔄 SYNC FROM CLOUD: Starting sync for user: $userEmail (UID: $userUid)',
    );

    String sourceDocumentId;

    // Check if user is a member of a shared account
    final memberDoc = await FirebaseFirestore.instance
        .collection('member_accounts')
        .doc(userUid)
        .get();

    if (memberDoc.exists) {
      // User is a member - sync from owner's document using OWNER'S EMAIL
      final ownerEmail = memberDoc.data()!['ownerEmail'] as String;
      sourceDocumentId = ownerEmail; // Use owner's email as document ID
      print(
        '🔄 SYNC FROM CLOUD: User is a member, syncing from owner email: $ownerEmail',
      );
    } else {
      // User is owner - sync from own document using OWN EMAIL
      sourceDocumentId = userEmail; // Use own email as document ID
      print(
        '🔄 SYNC FROM CLOUD: User is owner, syncing from own email: $userEmail',
      );
    }

    // Get the document
    final doc = await FirebaseFirestore.instance
        .collection('khatas')
        .doc(sourceDocumentId)
        .get();

    if (!doc.exists) {
      print('🔄 SYNC FROM CLOUD: No document found for ID: $sourceDocumentId');
      return false;
    }

    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> txnsRaw = data['transactions'] ?? [];
    if (txnsRaw.isEmpty) {
      print('🔄 SYNC FROM CLOUD: No transactions found in document');
      return false;
    }

    print('🔄 SYNC FROM CLOUD: Found ${txnsRaw.length} transactions to import');

    final box = Hive.box<Transaction>('transactions');
    int importedCount = 0;

    for (final txnMap in txnsRaw) {
      try {
        final txn = await TransactionEncryption.fromEncryptedJson(
          Map<String, dynamic>.from(txnMap),
        );
        // Only add if not already present
        if (!box.values.any((t) => t.id == txn.id)) {
          await box.add(txn);
          importedCount++;
        }
      } catch (e) {
        // Log and skip any failed decryptions
        print('🔄 SYNC FROM CLOUD: Decryption failed for transaction: $e');
      }
    }

    print(
      '✅ SYNC FROM CLOUD: Successfully imported $importedCount new transactions',
    );
    return importedCount > 0;
  }

  /// Automatically syncs to cloud after adding transactions
  Future<void> autoSyncToCloud() async {
    try {
      await syncToCloud();
    } catch (e) {
      print('🔄 AUTO SYNC TO CLOUD: Error during auto sync: $e');
    }
  }

  /// Starts automatic sync every 30 seconds
  void startAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        await syncToCloud();
        await syncFromCloud();
      } catch (e) {
        print('🔄 AUTO SYNC: Error during auto sync: $e');
      }
    });
    print('🔄 AUTO SYNC: Started automatic sync every 30 seconds');
  }

  /// Stops automatic sync
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
    print('🔄 AUTO SYNC: Stopped automatic sync');
  }

  /// Starts real-time sync listening to Firestore changes
  void startRealTimeSync() {
    _syncSubscription?.cancel();

    _syncSubscription = listenToKhataChanges().listen(
      (hasChanges) {
        if (hasChanges) {
          print('🔄 REAL-TIME SYNC: Changes detected and processed');
        }
      },
      onError: (error) {
        print('🔄 REAL-TIME SYNC: Error in real-time sync: $error');
      },
    );

    print('🔄 REAL-TIME SYNC: Started real-time sync');
  }

  /// Stops real-time sync
  void stopRealTimeSync() {
    _syncSubscription?.cancel();
    _syncSubscription = null;
    print('🔄 REAL-TIME SYNC: Stopped real-time sync');
  }

  /// Listens to Firestore changes for the current user and keeps local Hive in sync.
  /// For shared accounts, everyone listens to the owner's document.
  Stream<bool> listenToKhataChanges() async* {
    final authService = AuthService();
    if (!authService.isSignedIn) return;

    final userUid = authService.currentUser!.uid;
    final userEmail = authService.userEmail!;
    print(
      '🔄 LISTEN TO CHANGES: Starting listener for user: $userEmail (UID: $userUid)',
    );

    String targetDocumentId;

    // Check if user is a member of a shared account
    final memberDoc = await FirebaseFirestore.instance
        .collection('member_accounts')
        .doc(userUid)
        .get();

    if (memberDoc.exists) {
      // User is a member - listen to owner's document using OWNER'S EMAIL
      final ownerEmail = memberDoc.data()!['ownerEmail'] as String;
      targetDocumentId = ownerEmail; // Use owner's email as document ID
      print(
        '🔄 LISTEN TO CHANGES: User is a member, listening to owner email: $ownerEmail',
      );
    } else {
      // User is owner - listen to own document using OWN EMAIL
      targetDocumentId = userEmail; // Use own email as document ID
      print(
        '🔄 LISTEN TO CHANGES: User is owner, listening to own email: $userEmail',
      );
    }

    // Listen to the target document
    await for (final doc
        in FirebaseFirestore.instance
            .collection('khatas')
            .doc(targetDocumentId)
            .snapshots()) {
      if (doc.exists) {
        print('🔄 LISTEN TO CHANGES: Document updated, processing changes...');
        final data = doc.data() as Map<String, dynamic>;
        final txnsRaw = data['transactions'] ?? [];
        final box = Hive.box<Transaction>('transactions');

        int importedCount = 0;
        for (final txnMap in txnsRaw) {
          try {
            final txn = await TransactionEncryption.fromEncryptedJson(
              Map<String, dynamic>.from(txnMap),
            );
            if (!box.values.any((t) => t.id == txn.id)) {
              await box.add(txn);
              importedCount++;
            }
          } catch (e) {
            print('🔄 LISTEN TO CHANGES: Decryption error: $e');
          }
        }

        if (importedCount > 0) {
          print(
            '✅ LISTEN TO CHANGES: Imported $importedCount new transactions from real-time updates',
          );
          yield true; // Signal that changes were processed
        } else {
          yield false; // No new changes
        }
      } else {
        yield false; // Document doesn't exist
      }
    }
  }

  /// Gets the current sharing status and information
  Future<Map<String, dynamic>> getSharingStatus() async {
    final authService = AuthService();
    if (!authService.isSignedIn) {
      return {'isShared': false, 'isOwner': false, 'members': <String>[]};
    }

    final userUid = authService.currentUser!.uid;

    // Check if user is a member of a shared account
    final memberDoc = await FirebaseFirestore.instance
        .collection('member_accounts')
        .doc(userUid)
        .get();

    if (memberDoc.exists) {
      // User is a member
      final memberData = memberDoc.data()!;
      return {
        'isShared': true,
        'isOwner': false,
        'ownerEmail': memberData['ownerEmail'],
        'ownerName': memberData['ownerName'],
        'members': <String>[],
      };
    }

    // Check if user is an owner with members
    final membersQuery = await FirebaseFirestore.instance
        .collection('shared_accounts')
        .doc(userUid)
        .collection('members')
        .where('isActive', isEqualTo: true)
        .get();

    final memberEmails = membersQuery.docs
        .map((doc) => doc.data()['email'] as String)
        .where((email) => email.isNotEmpty)
        .toList();

    return {
      'isShared': memberEmails.isNotEmpty,
      'isOwner': memberEmails.isNotEmpty,
      'members': memberEmails,
    };
  }

  Future<bool> _isNetworkAvailable() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }

  /// Cleanup method to cancel all subscriptions and timers
  void dispose() {
    stopAutoSync();
    stopRealTimeSync();
  }
}
