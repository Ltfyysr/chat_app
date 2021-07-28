import 'package:chat_app/landing_page.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'package:easy_localization/easy_localization.dart';
void main() async{
  //EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "ChatApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ChangeNotifierProvider(
          create: (context)=> UserModel(),
          child: LandingPage()),
    );
  }
}
