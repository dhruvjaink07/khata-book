/// Quick test utility to check and fix data consistency issues
import 'package:khata/services/member_sharing_service.dart';
import 'package:khata/auth/auth_service.dart';

class DataConsistencyTest {
  static Future<void> testUserRole() async {
    print('🧪 TESTING USER ROLE AND DATA CONSISTENCY');

    final authService = AuthService();
    if (!authService.isSignedIn) {
      print('❌ User not signed in');
      return;
    }

    final userEmail = authService.userEmail!;
    final userUid = authService.currentUser!.uid;
    print('👤 Current user: $userEmail (UID: $userUid)');

    // Test sharing info
    final memberService = MemberSharingService();

    print('🔄 Getting shared account info...');
    final sharedInfo = await memberService.getSharedAccountInfo();

    if (sharedInfo == null) {
      print('📝 Result: User is not part of any shared account');
    } else {
      print('📝 Result: User is ${sharedInfo.isOwner ? 'OWNER' : 'MEMBER'}');
      print('📋 Owner: ${sharedInfo.ownerName} (${sharedInfo.ownerEmail})');
      print('👥 Members: ${sharedInfo.members.length}');

      if (sharedInfo.isOwner) {
        print('📋 Member list:');
        for (final member in sharedInfo.members) {
          print('   - ${member.name} (${member.email})');
        }
      }
    }

    print('✅ Test completed');
  }
}
