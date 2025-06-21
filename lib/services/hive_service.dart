import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata/auth/auth_service.dart';
import 'package:khata/features/transactions/domain/transaction.dart';

class HiveService {
  final box = Hive.box<Transaction>('transactions');

  Future<void> addTransaction(Transaction t) async {
    await box.add(t);
    await syncToCloud();
  }

  Future<List<Transaction>> getTransactions() async {
    return box.values.toList();
  }

  Future<void> syncToCloud() async {
    final authService = AuthService();
    if (!authService.isSignedIn) return;
    final userEmail = authService.userEmail!;
    final partnerEmail = await _getPartnerEmail(userEmail);

    final khataDoc = FirebaseFirestore.instance
        .collection('khatas')
        .doc(userEmail);
    final txns = box.values.map((t) => t.toJson()).toList();

    await khataDoc.set({
      'ownerEmail': userEmail,
      'sharedWith': partnerEmail != null ? [partnerEmail] : [],
      'transactions': txns,
      'lastSynced': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<String?> _getPartnerEmail(String userEmail) async {
    final doc = await FirebaseFirestore.instance
        .collection('khatas')
        .doc(userEmail)
        .get();
    if (doc.exists) {
      final data = doc.data();
      final sharedWith = data?['sharedWith'] as List<dynamic>?;
      if (sharedWith != null && sharedWith.isNotEmpty) {
        return sharedWith.first as String;
      }
    }
    return null;
  }
}
