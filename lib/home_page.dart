import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'locator.dart';
//sadece oturum açan kullanıcıların gördüğü sayfa

class HomePage extends StatelessWidget {

  final Function onSignOut;
  final User user;
  AuthBase authService =locator<FirebaseAuthService>();
  HomePage({Key? key, required this.onSignOut,required this.user, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(onPressed: _cikisYap, child: Text("Çıkış Yap", style: TextStyle(color: Colors.white),),)
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(child: Text("Hoşgeldiniz ${user.uid}"),),
    );
  }

  Future<bool> _cikisYap() async {
    bool sonuc=await authService.signOut();
    onSignOut();
    return sonuc;
  }
}







