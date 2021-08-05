import 'dart:io';

import 'package:chat_app/locator.dart';
import 'package:chat_app/model/konusma.dart';
import 'package:chat_app/model/mesaj.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/auth_base.dart';
import 'package:chat_app/services/fake_auth_service.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firebase_storage_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<MyUser> tumKullaniciListesi = [];

  MyUser? get user => null;

  @override
  Future<MyUser?> getCurrentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.getCurrentUser();
    } else {
      MyUser? _user = await _firebaseAuthService.getCurrentUser();
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      MyUser? _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<MyUser?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithFacebook();
    } else {
      MyUser? _user = await _firebaseAuthService.signInWithFacebook();
      bool _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      MyUser? _user = await _firebaseAuthService.createUserWithEmailandPassword(
          email, sifre);
      bool? _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailandPassword(
          email, sifre);
    } else {
      MyUser? _user =
          await _firebaseAuthService.signInWithEmailandPassword(email, sifre);
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  Future<bool?> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String?> uploadFile(
      String userID, String fileType, File? profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "Dosya indirme linki";
    } else {
      var profilFotoUrl = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto!);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoUrl);
      return profilFotoUrl;
    }
  }

  Future<List<MyUser>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _firestoreDBService
          .getAllUser(); //yukarıda tanımladığımız listeye erişecek,veritabanından burası doldurulacak
      //varsa verileri burdan al yoksa netten getir

      return tumKullaniciListesi;
    }
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool?> saveMessage(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveMessage(kaydedilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var konusmaListesi =
          await _firestoreDBService.getAllConversations(userID);
      for(var oankiKonusma in konusmaListesi){
        var userListesindekiKullanici = listedeUserBul(oankiKonusma.kimle_konusuyor.toString());

        if(userListesindekiKullanici != null){
          print("VERILER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilURL =userListesindekiKullanici.profilURL;
        }else{
          print("VERILER VERITABANINDAN OKUNDU");
          print("aranılan user daha önceden veritabanından getirilmemiş o yüzden veritabanından bu değeri okumalıyız");
          var _veritabanindanOkunanUser =await _firestoreDBService.readUser(oankiKonusma.kimle_konusuyor.toString());
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser!.userName;
          oankiKonusma.konusulanUserProfilURL =_veritabanindanOkunanUser.profilURL;
        }
      }
      return konusmaListesi;
    }
  }

  MyUser? listedeUserBul(String userID){
    for(int i=0; i<tumKullaniciListesi.length; i++){
      if(tumKullaniciListesi[i].userID == userID){
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }
}
