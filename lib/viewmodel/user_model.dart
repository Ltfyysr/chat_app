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
  String? emailHataMesaji;
  String? sifreHataMesaji;

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
      _user = null;
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
    try {
      state = ViewState.Busy;
      _user = await _userRepository!.signInWithGoogle();
      // if (_user != null)
      return _user;
      // else
      return null;
    } catch (e) {
      debugPrint("Viewmodeldeki sign in with google hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository!.signInWithFacebook();
      // if (_user != null)
      return _user;
      // else
      return null;
    } catch (e) {
      debugPrint("Viewmodeldeki sign in with facebook hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user =
            await _userRepository!.createUserWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki create user with email and password hata: " +
          e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository!.signInWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki sign in with email and password hata: " +
          e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalı";
      sonuc = false;
    } else
      sifreHataMesaji = null;
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailHataMesaji = null;
    return sonuc;
  }
}
