import 'package:chat_app/app/sohbet_page.dart';
import 'package:chat_app/model/konusma.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KonusmalarimPage extends StatefulWidget {
  const KonusmalarimPage({Key? key}) : super(key: key);

  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbetler"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user!.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;

            if(tumKonusmalar!.length>0){
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiKonusma = tumKonusmalar[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) =>SohbetPage(currentUser: _userModel.user, sohbetEdilenUser: MyUser.idveResim(userID: oankiKonusma.kimle_konusuyor.toString(), profilURL: oankiKonusma.konusulanUserProfilURL),),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(oankiKonusma.son_yollanan_mesaj.toString()),
                        subtitle: Text(oankiKonusma.konusulanUserName.toString()),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage: NetworkImage(
                              oankiKonusma.konusulanUserProfilURL.toString()),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );

            }else{
              return RefreshIndicator(// scrolview olmadan çalışmaz
                onRefresh: _konusmalarimListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.chat, color: Theme.of(context).primaryColor,size: 75,),
                          Text("Henüz herhangi bir sohbet bulunmamaktadır",textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
                        ],),
                    ),
                    height: MediaQuery.of(context).size.height-150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _konusmalarimiGetir() async {
    final _userModel = Provider.of<UserModel>(context);
    var konusmalarim = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user!.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();
    for (var konusma in konusmalarim.docs) {
      print("konusma: " + konusma.data().toString());
    }
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1)); //refreshındicatorın ne kadar döneceğini gösteren yapı
    return null;
  }
}
