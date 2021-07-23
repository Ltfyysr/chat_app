import 'package:chat_app/home_page.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model/user_model.dart';

class LandingPage extends StatefulWidget {
  final AuthBase authService;
  const LandingPage({Key? key, required this.authService}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late User _user;

  get key => null;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    var user = this._user;
    if (_user == null) {
      return SignInPage(key: key, onSignIn: (User) {
        _updateUser(User);
      }, authService: widget.authService,);
    } else {
      return HomePage( authService: widget.authService, user: _user , onSignOut: () {
        _updateUser(null!) ;
      },);
    }
  }

  Future<void> _checkUser() async {
    User? _user = await widget.authService.currentUser();
  }

  void _updateUser(User user) {
    setState(() {
      _user = user ;
    });
  }
}