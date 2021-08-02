import 'package:chat_app/app/hata_exception.dart';
import 'package:chat_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:chat_app/common_widget/social_log_in_button.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, Login }

class EmailveSifreLoginPage extends StatefulWidget {
  const EmailveSifreLoginPage({Key? key}) : super(key: key);

  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  late String? _email, _sifre;
  late String _butonText, _linkText;
  var _formType = FormType.Login;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState!.save();
    debugPrint("email: " + _email! + " sifre: " + _sifre!);
    final _userModel = Provider.of<UserModel>(context,
        listen: false); //usermodel a erişmek için yaptık
    if (_formType == FormType.Login) {
      try {
        MyUser? _girisYapanUser =
            await _userModel.signInWithEmailandPassword(_email!, _sifre!);
        if (_girisYapanUser != null)
          print("Oturum açan user id:" + _girisYapanUser.userID.toString());
      } on FirebaseAuthException catch (e) {
        print("hata ${e.code}");
        PlatformDuyarliAlertDialog(
          baslik: "Oturum Açma HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    } else {
      try {
        MyUser? _olusturulanUser =
            await _userModel.createUserWithEmailandPassword(_email!, _sifre!);
       if (_olusturulanUser != null)
         print("Oturum açan user id:" + _olusturulanUser.userID.toString());
      } on FirebaseAuthException catch (e) {
        print("hata ${e.code}");
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  Widget build(BuildContext context) {
    _butonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login
        ? "Hesabınız Yok Mu? Kayıt Olun"
        : "Hesabınız Var Mı? Giriş Yapın";

    final _userModel = Provider.of<UserModel>(context, listen: true);
    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş / Kayıt"),
      ),
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _userModel.emailHataMesaji != null
                              ? _userModel.emailHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Email',
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String? girilenEmail) {
                          _email = girilenEmail;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: _userModel.sifreHataMesaji != null
                              ? _userModel.sifreHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.visibility_off_rounded),
                          hintText: 'Şifre',
                          labelText: 'Şifre',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String? girilenSifre) {
                          _sifre = girilenSifre;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SocialLoginButton(
                          butonText: _butonText,
                          butonColor: Theme.of(context).primaryColor,
                          radius: 10,
                          onPressed: () => _formSubmit(),
                          butonIcon: Visibility(
                            child: Icon(Icons.opacity),
                            visible: false,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () => _degistir(),
                        child: Text(_linkText),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
