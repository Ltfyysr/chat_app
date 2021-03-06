import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
class MyUser {
  final String userID;
   String? email;
   String? userName;
   String ? profilURL;
   DateTime? createdAt;
   DateTime? updatedAt;
   int? seviye;

  MyUser({required this.userID, required this.email });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ?? email!.substring(0, email!.indexOf('@')) + randomSayiUret(),
      'profilURL': profilURL ?? 'https://www.datasciencearth.com/wp-content/uploads/2021/05/user-member-avatar-face-profile-icon-vector-22965342-e1619819871835.jpg',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map):
   userID = map['userID'],
   email = map['email'],
   userName = map['userName'],
   profilURL = map['profilURL'],
   createdAt = (map['createdAt'] as Timestamp).toDate(),
   updatedAt = (map['updatedAt'] as Timestamp).toDate(),
   seviye = map['seviye'];
  MyUser.idveResim({required this.userID, required this.profilURL});

  @override
  String toString() {
    return 'MyUser{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}

