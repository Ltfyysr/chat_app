import 'package:chat_app/model/user.dart';
abstract class AuthBase{
  Future<MyUser?> getCurrentUser();
  Future<MyUser?> signInAnonymously();
  Future<bool> signOut();
  Future<MyUser?> signInWithGoogle();
  Future<MyUser?> signInWithFacebook();
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre);
  Future<MyUser?> createUserWithEmailandPassword(String email, String sifre);

}