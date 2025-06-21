import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:khata/features/transactions/domain/transaction.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Signs in with Google and Firebase Auth.
  /// Returns [UserCredential] on success, or null if cancelled or failed.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  /// Signs out from both Google and Firebase, and clears local transactions.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    // Optionally clear local transactions
    final box = Hive.box<Transaction>('transactions');
    await box.clear();
  }

  /// Returns the current Firebase user, or null if not signed in.
  User? get currentUser => _auth.currentUser;

  /// Returns true if a user is signed in.
  bool get isSignedIn => _auth.currentUser != null;

  /// Returns the signed-in user's display name, or null.
  String? get userName => _auth.currentUser?.displayName;

  /// Returns the signed-in user's email, or null.
  String? get userEmail => _auth.currentUser?.email;

  /// Returns the signed-in user's photo URL, or null.
  String? get userPhotoUrl => _auth.currentUser?.photoURL;
}
