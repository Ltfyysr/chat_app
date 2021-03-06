import 'package:chat_app/model/konusma.dart';
import 'package:chat_app/model/mesaj.dart';
import 'package:chat_app/model/user.dart';

abstract class DBBase{
  Future<bool?> saveUser(MyUser user);
  Future<MyUser?> readUser(String userID);
  Future<bool?> updateUserName(String userID, String yeniUserName);
  Future<bool?> updateProfilFoto(String userID, String profilFotoURL);
  Future<List<MyUser>> getUserWithPagination(MyUser enSonGetirilenUser, int getirilecekElemanSayisi);
  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID);
  Future<bool?> saveMessage(Mesaj kaydedilecekMesaj);
  Future<List<Konusma>> getAllConversations(String userID);
  Future<DateTime?> saatiGoster(String userID);
}