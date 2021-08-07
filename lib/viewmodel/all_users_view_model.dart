import 'package:chat_app/model/user.dart';
import 'package:chat_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<MyUser>? _tumKullanicilar;
  MyUser? _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();
  List<MyUser>? get kullanicilarListesi => _tumKullanicilar;
  AllUserViewState get state => _state;

  // MyUser? get enSonGelenUser => _enSonGetirilenUser;
  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }
  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

  //refresh ve sayfalama için
  //yenielemanlar getir true yapılır
  //ilk açılıs için yenielemanlar için false deger verilir.
  getUserWithPagination(
      MyUser? enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {
    if (_tumKullanicilar!.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar!.last;
      print("en son getirilen username:" + _enSonGetirilenUser!.userName.toString());
    }

    if (yeniElemanlarGetiriliyor) {
    } else {
      state = AllUserViewState.Busy;
    }

    var yeniListe = await _userRepository.getUserWithPagination(
        _enSonGetirilenUser, sayfaBasinaGonderiSayisi);

    if (yeniListe.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    //yeniListe.forEach((usr) => print("Getirilen username:" + usr.userName));

    _tumKullanicilar!.addAll(yeniListe);

    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {
    // print("Daha fazla user getir tetiklendi - viewmodeldeyiz -");
    if (_hasMore) getUserWithPagination(_enSonGetirilenUser, true);
    //else
    //print("Daha fazla eleman yok o yüzden çagrılmayacak");
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    getUserWithPagination(_enSonGetirilenUser, true);
  }
}
