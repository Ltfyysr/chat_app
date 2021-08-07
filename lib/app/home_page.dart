import 'package:chat_app/app/konusmalarim_page.dart';
import 'package:chat_app/app/kullanicilar.dart';
import 'package:chat_app/app/my_custom_bottom_navi.dart';
import 'package:chat_app/app/profil.dart';
import 'package:chat_app/app/tab_items.dart';
import 'package:chat_app/viewmodel/all_users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';

//sadece oturum açan kullanıcıların gördüğü sayfa

class HomePage extends StatefulWidget {
  final MyUser? user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
          create: (context) => AllUserViewModel(),
          child: KullanicilarPage(),),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      // false dersek geriye gelme deriz
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]!.currentState!.popUntil(
                (route) => route.isFirst); //tanımlanan rotalardan ilkine git
          }else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}

/* Future<bool> _cikisYap(BuildContext context) async {

    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc=await _userModel.signOut();
    return sonuc;
  }*/
