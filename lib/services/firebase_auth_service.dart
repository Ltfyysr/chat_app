import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MyUser?> getCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("Hata Current User" + e.toString());
      return null;
    }
  }

  MyUser? _userFromFirebase(User? user) {
    if (user == null) return null;

    return MyUser(userID: user.uid, email: 'fakeuser@fake.com');
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Anonim giris hata : " + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("Sign out hata" + e.toString());
      return false;
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<MyUser?> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    FacebookLoginResult _faceResult = await _facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch (_faceResult.status) {
      case FacebookLoginStatus.success:
        if (_faceResult.accessToken != null) {
          UserCredential _firebaseResult = (await _firebaseAuth
              .signInWithCredential(FacebookAuthProvider.credential(
                  _faceResult.accessToken!.token)));
          User? _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        }
        break;
      case FacebookLoginStatus.cancel:
        print("Kullanıcı facebook girişi iptal etti");
        break;
      case FacebookLoginStatus.error:
        print("Hata çıktı :" + _faceResult.error.toString());
        break;
    }
    return null;
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String sifre) async {
    try {
      UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: sifre);
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Create User With Email and Password hata : " + e.toString());
      return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre) async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: sifre);
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Sign In With Email and Password hata : " + e.toString());
      return null;
    }
  }
}
