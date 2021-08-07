import 'package:chat_app/app/landing_page.dart';
import 'package:chat_app/theme_cubit.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'locator.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => UserModel(),
        child: BlocProvider(
        create: (context) => ThemeCubit(),
         child: BlocBuilder<ThemeCubit, ThemeData>(
         builder: (context, tema) {
          return MaterialApp(
            title: "ChatApp",
            debugShowCheckedModeBanner: false,
            theme: tema,
            home: LandingPage());},),
    ),);
  }
}
