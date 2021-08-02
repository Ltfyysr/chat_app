import 'package:chat_app/locator.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/services/fake_auth_service.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';
import 'package:flutter/cupertino.dart';

enum AppMode{DEBUG, RELEASE}

class UserRepository implements AuthBase{
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService = locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
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
      MyUser? _user = await  _firebaseAuthService.signInWithGoogle();
      bool _sonuc =await _firestoreDBService.saveUser(_user!);
      if(_sonuc){
        return await _firestoreDBService.readUser(_user.userID);
      }else return null;
    }
  }

  @override
  Future<MyUser?> signInWithFacebook() async{

    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signInWithFacebook();
    }else{
      MyUser? _user = await  _firebaseAuthService.signInWithFacebook();
      bool _sonuc =await _firestoreDBService.saveUser(_user!);
      if(_sonuc){
        return await _firestoreDBService.readUser(_user.userID);
      }else return null;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(String email, String sifre) async {
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.createUserWithEmailandPassword(email, sifre);
    }else{
        MyUser? _user = await  _firebaseAuthService.createUserWithEmailandPassword(email, sifre);
        bool? _sonuc =await _firestoreDBService.saveUser(_user!);
        if(_sonuc){
          return await _firestoreDBService.readUser(_user.userID);
        }else return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre) async{

    if(appMode == AppMode.DEBUG){
      return await _fakeAuthenticationService.signInWithEmailandPassword(email, sifre);
    }else{
      try{
        MyUser? _user =  await  _firebaseAuthService.signInWithEmailandPassword(email, sifre);
        return await _firestoreDBService.readUser(_user!.userID);
      }catch(e){
        debugPrint("repoda sign in user da hata var :"+e.toString());
      }
    }
  }

}