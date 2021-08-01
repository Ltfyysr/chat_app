import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase{
  String userID= "4444444444444";
  //MyUser? get user => null;

    @override
  Future<MyUser>  getCurrentUser() async {
      return await Future.value(MyUser(userID: userID, email: 'fakeuser@fake.com',));
    }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(Duration(seconds:2 ), ()=> MyUser(userID: userID, email: 'fakeuser@fake.com',));

  }

  @override
  Future<bool> signOut() {
    return Future.value(true);

  }

  @override
  Future<MyUser> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2), () => MyUser(userID: "google_user_id_123455", email: "fakeuser@fake.com", ));
  }

  @override
  Future<MyUser?> signInWithFacebook() async{

    return await Future.delayed(Duration(seconds: 2), () => MyUser(userID: "facebook_user_id_123455", email: "fakeuser@fake.com", ));
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(String email, String sifre)  async{

    return await Future.delayed(Duration(seconds: 2), () => MyUser(userID: "created_user_id_123455", email: "fakeuser@fake.com", ));
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre) async{

    return await Future.delayed(Duration(seconds: 2), () => MyUser(userID: "sign_in_user_id_123455", email: "fakeuser@fake.com", ));
  }
}