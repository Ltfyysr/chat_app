import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/model/user_model.dart';
abstract class AuthBase{
  Future<MyUser?> getCurrentUser();
  Future<MyUser?> signInAnonymously();
  Future<bool> signOut();
  Future<MyUser?> signInWithGoogle();
}