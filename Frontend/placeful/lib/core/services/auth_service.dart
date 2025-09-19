import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    return await user?.getIdToken();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() => _auth.currentUser;
}