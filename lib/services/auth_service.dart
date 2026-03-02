import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth state changes stream
  Stream<User?> get user => _auth.authStateChanges();

  // Sign in with email and password
  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Sign In Error: ${e.code}");
      return _getErrorMessage(e.code);
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // Register with email and password
  Future<dynamic> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Sign Up Error: ${e.code}");
      return _getErrorMessage(e.code);
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'No user found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'email-already-in-use': return 'Email is already registered.';
      case 'invalid-email': return 'Email address is invalid.';
      case 'weak-password': return 'Password is too weak.';
      default: return 'Authentication failed. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
