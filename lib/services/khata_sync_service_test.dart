import 'dart:async';
import 'package:khata/services/khata_sync_service.dart';
import 'package:khata/auth/auth_service.dart';

/// Simple test to verify sync logic
/// This is a development test - not for production
class KhataSyncServiceTest {
  static Future<void> testSyncLogic() async {
    print('🧪 Testing Khata Sync Service...');

    final syncService = KhataSyncService();
    final authService = AuthService();

    if (!authService.isSignedIn) {
      print('❌ User not signed in - cannot test sync');
      return;
    }

    try {
      print('📡 Testing sync to cloud...');
      await syncService.syncToCloud();
      print('✅ Sync to cloud successful');

      print('📡 Testing sync from cloud...');
      final hasData = await syncService.syncFromCloud();
      print('✅ Sync from cloud successful: $hasData');

      print('📊 Testing sharing status...');
      final status = await syncService.getSharingStatus();
      print('✅ Sharing status: $status');

      print('🔄 Testing real-time sync setup...');
      syncService.startRealTimeSync();
      print('✅ Real-time sync started');

      // Test for a few seconds
      await Future.delayed(const Duration(seconds: 5));

      syncService.stopRealTimeSync();
      print('✅ Real-time sync stopped');

      print('✅ All sync tests passed!');
    } catch (e) {
      print('❌ Test failed: $e');
    }
  }
}
