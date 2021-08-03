import 'dart:io';

import 'package:chat_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:chat_app/common_widget/social_log_in_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late TextEditingController _controllerUserName;

  File? _profilFoto;

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

  void _kameradanFotoCek() async {
    var _yeniResim =
    await ImagePicker.platform.pickImage(source: ImageSource.camera);

    setState(() {
      _profilFoto = File(_yeniResim!.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _profilFoto = File(_yeniResim!.path);
      Navigator.of(context).pop();
    });
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
          TextButton(
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
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _kameradanFotoCek();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _galeridenResimSec();
                                  },
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: _profilFoto == null
                        ? NetworkImage(
                      _userModel.user!.profilURL.toString(),
                    )
                        : FileImage(_profilFoto!) as ImageProvider,
                  ),
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
                      _profilFotoGuncelle(context);
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
        _controllerUserName.text = _userModel.user!.userName!;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "UserName zaten kullanımda, farklı bir UserName deneyiniz!",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user!.userID, "profil_foto", _profilFoto);
      print("gelen url :" + url!);

      if (url != null) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Profil fotoğrafı başarılı bir şekilde güncellendi.",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }
}
