import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//sadece oturum açan kullanıcıların gördüğü sayfa

class HomePage extends StatelessWidget {

  final User user;
  HomePage({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: ()=> _cikisYap(context), child: Text("Çıkış Yap", style: TextStyle(color: Colors.white),),)
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(child: Text("Hoşgeldiniz ${user.uid}"),),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    bool sonuc=await _userModel.signOut();
    return sonuc;
  }
}







