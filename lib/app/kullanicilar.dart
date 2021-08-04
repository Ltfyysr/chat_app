import 'package:chat_app/app/konusmalarim_page.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  const KullanicilarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    // _userModel.getAllUser();
    return Scaffold(
        appBar: AppBar(title: Text("Kullanıcılar")),
        body: FutureBuilder<List<MyUser>>(
            future: _userModel.getAllUser(),
            builder: (context, sonuc) {
              if (sonuc.hasData) {
                var tumKullanicilar = sonuc.data;
                if (tumKullanicilar!.length - 1 > 0) {
                  return ListView.builder(
                    itemCount: tumKullanicilar.length,
                    itemBuilder: (context, index) {
                      var oankiUser = sonuc.data![index];
                      if (oankiUser.userID !=
                          _userModel.user!.userID) {
                        return GestureDetector(
                          onTap: () {
                            Navigator
                                .of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => KonusmalarimPage(sohbetEdilenUser: oankiUser, currentUser: _userModel.user,),),);
                            },
                          child: ListTile(
                            title: Text(oankiUser.userName.toString()),
                            subtitle: Text(oankiUser.email.toString()),
                            leading: CircleAvatar(backgroundImage: NetworkImage(
                                oankiUser.profilURL.toString()),),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Text("Kullanıcı kaydı bulunmamaktadır."),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
