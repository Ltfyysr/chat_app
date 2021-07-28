import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthenticationService implements AuthBase{
  String userID= "4444444444444";
  MyUser? get user => null;

    @override
  Future<MyUser>  getCurrentUser() async {
      return await Future.value(MyUser(userID: userID));
    }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(Duration(seconds:2 ), ()=> MyUser(userID: userID));

  }

  @override
  Future<bool> signOut() {
    return Future.value(true);

  }

  @override
  Future<MyUser> signInWithGoogle(){
    return null!;
  }

}