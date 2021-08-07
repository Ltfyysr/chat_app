import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {

  ThemeCubit() : super(_acikTema);
  static final _acikTema = ThemeData(

      //scaffoldBackgroundColor:  Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple, //içinde bulunan iconun rengi
      ),
      primarySwatch: Colors.deepPurple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      backgroundColor: Colors.deepPurple.shade100,
      brightness: Brightness.light);
  static final _koyuTema = ThemeData(
     // scaffoldBackgroundColor: Colors.white12,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white, backgroundColor: Colors.white),
      primarySwatch: Colors.grey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      backgroundColor: Colors.black12,
      bottomAppBarColor: Colors.white,
      buttonColor: Colors.grey,
      cursorColor: Colors.grey,
      brightness: Brightness.dark);

  void temaDegistir() {
    emit(state.brightness == Brightness.dark ? _acikTema : _koyuTema);
  }
}

