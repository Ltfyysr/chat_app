import 'package:chat_app/sign_in_page.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user_model.dart';
//sadece oturum açan kullanıcıların gördüğü sayfa

class HomePage extends StatefulWidget {
  final MyUser? user;
  HomePage({Key? key,required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  MyUser? get user => null;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: ()=> _cikisYap(context), child: Text("Çıkış Yap", style: TextStyle(color: Colors.white),),)
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(child: Text("Hoşgeldiniz"),),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {

    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc=await _userModel.signOut();
    return sonuc;
  }
}







