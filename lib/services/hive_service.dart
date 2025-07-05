import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata/features/transactions/domain/transaction.dart';
import 'package:khata/services/khata_sync_service.dart';

class HiveService {
  final box = Hive.box<Transaction>('transactions');

  Future<void> addTransaction(Transaction t) async {
    await box.add(t);
    // Auto-sync to cloud for real-time collaboration
    await KhataSyncService().autoSyncToCloud();
  }

  Future<List<Transaction>> getTransactions() async {
    return box.values.toList();
  }

  // Start real-time sync when the app starts
  void startRealtimeSync() {
    KhataSyncService().startRealTimeSync();
  }

  // Stop real-time sync when the app closes
  void stopRealtimeSync() {
    KhataSyncService().stopRealTimeSync();
  }
}
