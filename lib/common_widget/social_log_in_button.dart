import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key? key,
        required this.butonText,
        this.butonColor: Colors.deepPurple,
        this.textColor: Colors.white,
        this.radius: 16,
        this.yukseklik: 40,
        required this.butonIcon,
        required this.onPressed})
      : assert(butonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: yukseklik,
        // ignore: deprecated_member_use
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Eski yöntem
                // (ek butonda icon tanımlamazsak hata veriyordu.
                // Onu önlemek için yazıyoruz.)
                /* butonIcon != null ? butonIcon : Container(),
                      Text(
                        butonText,
                        style: TextStyle(color: textColor),
                      ),
                      butonIcon != null
                          ? Opacity(opacity: 0, child: butonIcon)
                          : Container(),
                */
                //Spreads, Collection-if(tek bir değer döndereceksek),collection-for
                //burda sondaki butona icon olmaması durumunda ne yapacağımızı belirtiyoruz
                //yeni yöntem buu(spreads yapısı)
                if (butonIcon != null) ...[
                  //butonIcon bu ise(null değilse) böyle bir liste koy
                  butonIcon,
                  Text(
                    butonText,
                    style: TextStyle(color: textColor),
                  ),
                  Opacity(opacity: 0, child: butonIcon)
                ],
                if (butonIcon == null) ...[
                  //butonIcon null ise böyle bir liste koy
                  Container(),
                  Text(
                    butonText,
                    style: TextStyle(color: textColor),
                  ),
                  Container(),
                ]
              ]),
          color: butonColor,
        ),
      ),
    );
  }
}
