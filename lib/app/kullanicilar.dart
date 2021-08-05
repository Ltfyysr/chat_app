import 'package:chat_app/app/sohbet_page.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  const KullanicilarPage({Key? key}) : super(key: key);

  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(title: Text("Kullanıcılar")),
        body: FutureBuilder<List<MyUser>>(
            future: _userModel.getAllUser(),
            builder: (context, sonuc) {
              if (sonuc.hasData) {
                var tumKullanicilar = sonuc.data;
                if (tumKullanicilar!.length - 1 > 0) {
                  return RefreshIndicator(
                    onRefresh: _kullanicilarListesiniGuncelle,
                    child: ListView.builder(
                      itemCount: tumKullanicilar.length,
                      itemBuilder: (context, index) {
                        var oankiUser = sonuc.data![index];
                        if (oankiUser.userID != _userModel.user!.userID) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => SohbetPage(
                                    sohbetEdilenUser: oankiUser,
                                    currentUser: _userModel.user,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(oankiUser.userName.toString()),
                              subtitle: Text(oankiUser.email.toString()),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.withAlpha(40),
                                backgroundImage: NetworkImage(
                                    oankiUser.profilURL.toString()),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  );
                } else {

                  return RefreshIndicator(// scrolview olmadan çalışmaz
                    onRefresh: _kullanicilarListesiniGuncelle,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.supervised_user_circle, color: Theme.of(context).primaryColor,size: 100,),
                              Text("Henüz bir kullanıcı bulunmamaktadır", textAlign: TextAlign.center,style: TextStyle(fontSize: 25),),
                            ],),
                        ),
                        height: MediaQuery.of(context).size.height-150,
                      ),
                    ),
                  );

                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<Null> _kullanicilarListesiniGuncelle() async {
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
