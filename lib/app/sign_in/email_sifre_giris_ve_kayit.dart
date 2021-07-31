import 'package:chat_app/common_widget/social_log_in_button.dart';
import 'package:flutter/material.dart';

class EmailveSifreLoginPage extends StatefulWidget {
  const EmailveSifreLoginPage({Key? key}) : super(key: key);

  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  @override
  late String? _email, _sifre;
  final _formKey = GlobalKey<FormState>();

  _formSubmit(BuildContext context) {
    _formKey.currentState!.save();
    debugPrint("email: " + _email! + " sifre: " + _sifre!);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş / Kayıt"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                      butonText: "Giriş Yap",
                      butonColor: Theme.of(context).primaryColor,
                      radius: 10,
                      onPressed: () => _formSubmit(context),
                      butonIcon: Visibility(
                        child: Icon(Icons.opacity),
                        visible: false,
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
