import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:hive/hive.dart';
import 'package:khata/auth/auth_service.dart';
import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class KhataSyncService {
  static final KhataSyncService _instance = KhataSyncService._internal();
  factory KhataSyncService() => _instance;
  KhataSyncService._internal();

  /// Syncs all local transactions to Firestore for the current user and partner.
  Future<void> syncToCloud({String? partnerEmail}) async {
    if (!await _isNetworkAvailable()) {
      throw Exception(
        'No internet connection. Please connect to the internet to sync.',
      );
    }
    final authService = AuthService();
    if (!authService.isSignedIn) return;
    final userEmail = authService.userEmail!;
    final khataDoc = FirebaseFirestore.instance
        .collection('khatas')
        .doc(userEmail);
    final box = Hive.box<Transaction>('transactions');
    final txns = await Future.wait(box.values.map((t) => t.toEncryptedJson()));

    await khataDoc.set({
      'ownerEmail': userEmail,
      'sharedWith': (partnerEmail != null && partnerEmail.isNotEmpty)
          ? [partnerEmail]
          : [],
      'transactions': txns,
      'lastSynced': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Fetches and imports transactions from Firestore for the current user (owner or partner).
  Future<bool> syncFromCloud() async {
    if (!await _isNetworkAvailable()) {
      throw Exception(
        'No internet connection. Please connect to the internet to sync.',
      );
    }
    final authService = AuthService();
    if (!authService.isSignedIn) return false;
    final userEmail = authService.userEmail!;
    DocumentSnapshot? doc;

    // Try as owner
    doc = await FirebaseFirestore.instance
        .collection('khatas')
        .doc(userEmail)
        .get();
    if (!doc.exists) {
      // Try as partner
      final query = await FirebaseFirestore.instance
          .collection('khatas')
          .where('sharedWith', arrayContains: userEmail)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        doc = query.docs.first;
      }
    }

    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> txnsRaw = data['transactions'] ?? [];
    if (txnsRaw.isEmpty) return false;

    final box = Hive.box<Transaction>('transactions');
    for (final txnMap in txnsRaw) {
      try {
        final txn = await TransactionEncryption.fromEncryptedJson(
          Map<String, dynamic>.from(txnMap),
        );
        if (!box.values.any((t) => t.id == txn.id)) {
          await box.add(txn);
        }
      } catch (e) {
        // Log and skip any failed decryptions
        print('Decryption failed: $e');
      }
    }
    return true;
  }

  /// Listens to Firestore changes for the current user (owner or partner) and keeps local Hive in sync.
  Stream<void> listenToKhataChanges(String userEmail) {
    final ownerStream = FirebaseFirestore.instance
        .collection('khatas')
        .doc(userEmail)
        .snapshots();

    final partnerStream = FirebaseFirestore.instance
        .collection('khatas')
        .where('sharedWith', arrayContains: userEmail)
        .snapshots();

    return MergeStream<void>([
      ownerStream.asyncMap((doc) async {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final txnsRaw = data['transactions'] ?? [];
          final box = Hive.box<Transaction>('transactions');
          for (final txnMap in txnsRaw) {
            try {
              final txn = await TransactionEncryption.fromEncryptedJson(
                Map<String, dynamic>.from(txnMap),
              );
              if (!box.values.any((t) => t.id == txn.id)) {
                await box.add(txn);
              }
            } catch (e) {
              print('Decryption error (ownerStream): $e');
            }
          }
        }
      }),
      partnerStream.asyncMap((query) async {
        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          final data = doc.data();
          final txnsRaw = data['transactions'] ?? [];
          final box = Hive.box<Transaction>('transactions');
          for (final txnMap in txnsRaw) {
            try {
              final txn = await TransactionEncryption.fromEncryptedJson(
                Map<String, dynamic>.from(txnMap),
              );
              if (!box.values.any((t) => t.id == txn.id)) {
                await box.add(txn);
              }
            } catch (e) {
              print('Decryption error (partnerStream): $e');
            }
          }
        }
      }),
    ]);
  }

  Future<bool> _isNetworkAvailable() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }
}
