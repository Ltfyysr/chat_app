import 'package:chat_app/model/user_model.dart';

abstract class DBBase{

  Future<bool?> saveUser(MyUser user);


}