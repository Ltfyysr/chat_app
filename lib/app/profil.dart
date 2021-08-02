import 'package:chat_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:chat_app/common_widget/social_log_in_button.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late TextEditingController _controllerUserName;

  // late File _profilFoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.user!.userName!;
    print("Profil sayfasındaki user değerleri :" + _userModel.user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          FlatButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      NetworkImage(_userModel.user!.profilURL.toString()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Emailiniz",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  //initialValue: _userModel.user!.userName,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adınız",
                    hintText: "userName",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                    butonText: "Değişiklikleri Kaydet",
                    butonIcon: Visibility(
                      child: Icon(Icons.opacity),
                      visible: false,
                    ),
                    onPressed: () {
                      _userNameGuncelle(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user!.userID, _controllerUserName.text);
      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "UserName değiştirildi.",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      } else {
        _controllerUserName.text =_userModel.user!.userName!;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "UserName zaten kullanımda, farklı bir UserName deneyiniz!",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    } else {
      PlatformDuyarliAlertDialog(
        baslik: "Hata",
        icerik: "UserName değişikliği yapmadınız!",
        anaButonYazisi: 'Tamam',
      ).goster(context);
    }
  }
}
