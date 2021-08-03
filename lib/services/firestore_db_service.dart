import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/database_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser user) async {
    DocumentSnapshot _okunanUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}").get();

    if (_okunanUser.data() == null) {
      print("nullll");
      print(_okunanUser.toString());
      await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<MyUser?> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("users").doc(userID).get();
    Map<String, dynamic>? _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>?;

    MyUser _okunanUserNesnesi = MyUser.fromMap(_okunanUserBilgileriMap!);
    print("Okunan user nesnesi :" + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }
  @override
  Future<bool?> updateUserName(String userID, String yeniUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .doc(userID)
          .update({'userName': yeniUserName});
      return true;
    }
  }
  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoUrl) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({'profilURL': profilFotoUrl});
    return true;
  }
  @override
  Future<List<MyUser>> getAllUser() async {
    QuerySnapshot? _querySnapshot = await FirebaseFirestore.instance.collection("users").get();

    List<MyUser> tumKullanicilar = [];
    for (DocumentSnapshot tekUser in _querySnapshot.docs) {
      //print("okunan user :"+tekUser.data().toString());
      MyUser _tekUser = MyUser.fromMap(tekUser.data() as Map<String, dynamic>);
      tumKullanicilar.add(_tekUser);
    }
    //map metodu ile
    //tumKullanicilar = _querySnapshot.docs.map((tekSatir) => MyUser.fromMap(tekSatir.data().toList();

    return tumKullanicilar;
  }


}
