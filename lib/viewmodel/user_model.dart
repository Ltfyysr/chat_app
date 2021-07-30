import 'package:chat_app/locator.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/repository/user_repository.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository? _userRepository = locator<UserRepository>();
  MyUser? _user;

  MyUser? get user => _user;

  ViewState get state => _state;


  set state(ViewState value) {
    _state = value;
    notifyListeners(); //ne zaman idle dan busy ya da busy den idle yapcam o zaman arayüzümüze bilgi veriyoruz.
  }

  UserModel() {
    getCurrentUser();
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    late MyUser? _user;

    // await EasyLocalization.ensureInitialized();
    try {
      state = ViewState.Busy;
      _user = await _userRepository!.getCurrentUser();
      if (_user == null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    late MyUser? _user;
    try {
      state = ViewState.Busy;
      _user = await _userRepository!.signInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("Viewmodeldeki sign in anonymously hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository!.signOut();
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki sign out hata: " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    late MyUser? _user;
    try {
      state = ViewState.Busy;
      _user = await _userRepository!.signInWithGoogle();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki sign in with google hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }
}