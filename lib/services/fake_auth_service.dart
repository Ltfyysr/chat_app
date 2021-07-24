import 'package:chat_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthenticationService implements AuthBase{
  String userID= "4444444444444";
  late User _user;
    @override
  Future<User> currentUser() async{
    return await Future.value(_user);

  }

  @override
  Future<User> signInAnonymously() async {
    return await Future.delayed(Duration(seconds:2 ), ()=> _user);

  }

  @override
  Future<bool> signOut() {
    return Future.value(true);

  }

}