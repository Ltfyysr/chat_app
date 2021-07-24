import 'package:chat_app/home_page.dart';
import 'package:chat_app/locator.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/model/user_model.dart';

class LandingPage extends StatefulWidget {

 // const LandingPage({Key? key, required this.authService}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late User _user;
  get key => null;
 AuthBase authService =locator<FirebaseAuthService>();

  get uid => null;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return SignInPage(key: key, onSignIn: (User) {
        _updateUser(User);
      },);
    } else {
      return HomePage( authService:authService, user: uid , onSignOut: () {
        _updateUser(uid) ;
      },);
    }
  }

  Future<void> _checkUser() async {
    User? _user = (await authService.currentUser());
  }

  void _updateUser(User user) {
    setState(() {
      _user = user ;
    });
  }
}