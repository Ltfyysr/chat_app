import 'package:chat_app/locator.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/services/fake_auth_service.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AppMode{DEBUG, RELEASE}

class UserRepository implements AuthBase{
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService = locator<FakeAuthenticationService>();

  AppMode appMode=AppMode.DEBUG;

  @override
  Future<User> currentUser() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.currentUser();
    }else{
      return await _firebaseAuthService.currentUser();
    }

  }

  @override
  Future<User> signInAnonymously() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signInAnonymously();
    }else{
      return await  _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signOut();
    }else{
     return await  _firebaseAuthService.signOut();
    }
  }

}