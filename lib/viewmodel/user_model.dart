
import 'package:chat_app/locator.dart';
import 'package:chat_app/repository/user_repository.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


enum ViewState{Idle, Busy}
class UserModel with ChangeNotifier implements AuthBase{
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository= locator<UserRepository>();
  late User _user;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners(); //ne zaman idle dan busy ya da busy den idle yapcam o zaman arayüzümüze bilgi veriyoruz.
  }
  UserModel(){
    currentUser();
     }


  @override
  Future<User> currentUser() async {
    await EasyLocalization.ensureInitialized();
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata: " + e.toString());
      return null!;
    } finally {
      state = ViewState.Idle;
    }
  }
  @override
  Future<User> signInAnonymously() async{

    try {
      state = ViewState.Busy;
      _user =await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata: " + e.toString());
      return null!;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async{
    try {
      state = ViewState.Busy;
      bool sonuc =  await _userRepository.signOut();
      _user == null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki sign out hata: " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }
}







