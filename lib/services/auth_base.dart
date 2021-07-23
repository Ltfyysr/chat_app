import 'package:chat_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase{
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<bool> signOut();
}