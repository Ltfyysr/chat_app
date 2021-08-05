import 'package:chat_app/model/mesaj.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/viewmodel/user_model.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:easy_localization/easy_localization.dart';
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
  ScrollController _scrollController = new ScrollController();

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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var tumMesajlar = streamMesajlarListesi.data;
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return _konusmaBalonuOlustur(tumMesajlar![index]);
                      },
                      itemCount: tumMesajlar!.length,
                    );
                  }),
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
                      onPressed: () async {
                        if (_mesajController.text.trim().length > 0) {
                          //sağında solunda boşluk varsa bunları silssin , bunu trimlesin ve kullanıcının boş bir mesaj yollamasını da engellesin.

                          Mesaj _kaydedilecekMesaj = Mesaj(
                            kimden: _currentUser.userID,
                            bendenMi: true,
                            mesaj: _mesajController.text,
                            kime: _sohbetEdilenUser.userID,
                          );
                          var sonuc =
                              await _userModel.saveMessage(_kaydedilecekMesaj);
                          if (sonuc == true) {
                            _mesajController.clear();
                            _scrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.easeOut,
                            ); //mesaj attıktan sonra sayfada anlık son mesajı göster
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

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.deepPurple.shade300;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    var _saatDakikaDegeri = "";
    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1,1));
    } catch (e) {
      print("hata var! :" + e.toString());
    }
    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi == true) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _gidenMesajRenk),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      widget.sohbetEdilenUser.profilURL.toString()),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _gelenMesajRenk),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj.toString()),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp? date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date!.toDate());
    return _formatlanmisTarih;
  }
}