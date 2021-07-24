import 'package:chat_app/home_page.dart';
import 'package:chat_app/sign_in_page.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/model/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);

    if(_userModel.state== ViewState.Idle){
      if(_userModel.user == null){
        return SignInPage();
      }else{
        return HomePage(user: _userModel.user);
      }
    }else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }
  }

}