import 'package:chat_app/model/user.dart';
import 'package:flutter/material.dart';

class Konusma extends StatefulWidget {
  Konusma({ required this.currentUser, required this.sohbetEdilenUser});
  final MyUser? currentUser;
  final MyUser sohbetEdilenUser;

  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(children: [Text("current user :"+widget.currentUser!.userName.toString()),
        Text("sohbet edilen user :"+widget.sohbetEdilenUser.userName.toString()),],),
      ),
    );
  }
}
