import 'package:chat_app/model/mesaj.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  KonusmalarimPage({required this.currentUser, required this.sohbetEdilenUser});

  final MyUser? currentUser;
  final MyUser sohbetEdilenUser;

  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  var _mesajController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyUser? _currentUser = widget.currentUser;
    MyUser? _sohbetEdilenUser = widget.sohbetEdilenUser;
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Mesaj>>(
                  stream: _userModel.getMessages(
                      _currentUser!.userID, _sohbetEdilenUser.userID),
                  builder: (context, streamMesajlarListesi) {
                    if (!streamMesajlarListesi.hasData) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    var tumMesajlar = streamMesajlarListesi.data;
                    return ListView.builder(itemBuilder: (context, index) {
                      return Text(tumMesajlar![index].mesaj.toString());
                    }, itemCount: tumMesajlar!.length,);
                  }
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mesajController,
                      cursorColor: Colors.blueGrey,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.deepPurple.shade50,
                        filled: true,
                        hintText: "Mesajınızı yazın",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(
                        Icons.navigation_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: ()async {
                        if (_mesajController.text
                            .trim()
                            .length > 0) {
                          //sağında solunda boşluk varsa bunları silssin , bunu trimlesin ve kullanıcının boş bir mesaj yollamasını da engellesin.


                          Mesaj _kaydedilecekMesaj = Mesaj(
                            kimden: _currentUser.userID,
                            bendenMi: true,
                            mesaj: _mesajController.text,
                            kime: _sohbetEdilenUser.userID,
                          );
                         var sonuc = await  _userModel.saveMessage(_kaydedilecekMesaj);
                         if(sonuc == true){
                           _mesajController.clear();
                         }
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
