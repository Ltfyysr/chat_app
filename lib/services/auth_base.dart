import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase{
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<bool> signOut();
  //Future<User> signInWithGmail();
}