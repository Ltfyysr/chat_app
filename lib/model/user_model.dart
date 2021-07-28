
class MyUser{
final String userID;

MyUser({required this.userID});

Map<String, dynamic> toMap() {
  return {
    'userID': userID,};

}
MyUser.fromMap(Map<String, dynamic> map)
    : userID = map['userID'];

@override
String toString() {
  return 'User{userID: $userID,}';}}