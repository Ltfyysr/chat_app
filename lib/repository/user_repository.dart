import 'package:chat_app/locator.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/services/fake_auth_service.dart';
import 'package:chat_app/services/firebase_auth_service.dart';

enum AppMode{DEBUG, RELEASE}

class UserRepository implements AuthBase{
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService = locator<FakeAuthenticationService>();

  AppMode appMode=AppMode.RELEASE;
  MyUser? get user => null;
  @override
  Future<MyUser?> getCurrentUser() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.getCurrentUser();
    }else{
      return await _firebaseAuthService.getCurrentUser();
    }

  }

  @override
  Future<MyUser?> signInAnonymously() async{
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

  @override
  Future<MyUser?> signInWithGoogle()async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signInWithGoogle();
    }else{
      return await  _firebaseAuthService.signInWithGoogle();
    }
  }

  @override
  Future<MyUser?> signInWithFacebook() async{

    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signInWithFacebook();
    }else{
      return await  _firebaseAuthService.signInWithFacebook();
    }
  }

}