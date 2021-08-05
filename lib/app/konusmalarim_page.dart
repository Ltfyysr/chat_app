import 'package:chat_app/model/konusma.dart';
import 'package:chat_app/viewmodel/user_model.dart';
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
        builder: (context, konusmaListesi){
          if (!konusmaListesi.hasData){
            return Center(child: CircularProgressIndicator(),);
          }else{
            var tumKonusmalar= konusmaListesi.data;
            return ListView.builder(itemBuilder:(context,index){
              var oankiKonusma = tumKonusmalar![index];
              return ListTile(title:Text(oankiKonusma.son_yollanan_mesaj.toString()),
              subtitle: Text(oankiKonusma.kimle_konusuyor.toString()),);
            },itemCount:tumKonusmalar!.length ,);
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
}
