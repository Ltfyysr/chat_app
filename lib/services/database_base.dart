import 'package:chat_app/model/user.dart';

abstract class DBBase{

  Future<bool?> saveUser(MyUser user);
  Future<MyUser?> readUser(String userID);


}