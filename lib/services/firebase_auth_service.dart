import 'package:chat_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser as User;
      return _userFromFirebase(user);
    } catch (e) {
      print("Hata Current User" + e.toString());
      throw UnimplementedError();
    }
  }

  User _userFromFirebase(User user) {
    if (user == null)
      throw UnimplementedError();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user as User);
    } catch (e) {
      print("Anonim giris hata : " + e.toString());
      throw UnimplementedError();
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("Sign out hata" + e.toString());
      return false;
    }
  }

}