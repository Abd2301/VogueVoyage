import 'package:firebase_auth/firebase_auth.dart';
import 'package:clothing/features/text.dart';


class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: email);
        showToast(message: password);
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: email);
        showToast(message: password);       
        showToast(message: 'Signup error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: email);
        showToast(message: password);
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: email);
        showToast(message: password);
        showToast(message: 'Signin error occurred: ${e.code}');
      }
    }
    return null;
  }
}
