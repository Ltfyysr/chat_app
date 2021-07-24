import 'package:chat_app/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/common_widget/social_log_in_button.dart';
import 'package:provider/provider.dart';
import 'model/user_model.dart';

class SignInPage extends StatelessWidget {

void _misafirGirisi(BuildContext context) async{
  final _userModel = Provider.of<UserModel>(context);
  User _user =await _userModel.signInAnonymously();
  print("oturum açan user id: "+_user.uid.toString());
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        //color: Colors.deepPurple.shade300, ile arka plan rengini değiştiriyoruz
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OTURUM AÇIN",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(
              height: 8,
            ),
            SocialLoginButton(
              butonText: "Gmail ile Giriş Yap",
              textColor: Colors.black87,
              butonColor: Colors.white,
              butonIcon: Image.asset("images/google-logo.png"),
              onPressed: () {},
            ),
             SocialLoginButton(
                butonText: "Facebook ile Giriş Yap",
                onPressed: () {},
                butonColor: Color(0xFF334D92),
                butonIcon: Image.asset("images/facebook-logo.png"),
              ),
             SocialLoginButton(
              onPressed: () {},
              butonText: "Email ve Şifre ile Giriş Yap",
              butonColor: Color(0xFF7E57C2),
              butonIcon: Icon(
                Icons.email,
                color: Colors.white,
                size: 32,
              ),
            ),
            SocialLoginButton(
              onPressed: ()=>_misafirGirisi(context),
              butonColor: Colors.teal,
              butonText: "Misafir Giriş Yap", butonIcon: Icon(Icons.supervised_user_circle,color: Colors.black12,size: 32,) 
            ),
          ],
        ),
      ),
    );
  }
}




