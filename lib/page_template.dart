import 'package:FoodWatch/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final List<Widget> buttons;
  final Widget child;
  final Color color;

  const PageTemplate(
      {Key key, @required this.buttons, @required this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color defaultColor =
        (isDarkmode(context)) ? ItemColorDark.black : ItemColor.white;
    final Color realColor = color ?? defaultColor;
    return Container(
        height: double.infinity,
        color: (isDarkmode(context))
            ? ItemColorDark.darkGrey
            : ItemColor.periwinkle,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SafeArea(bottom: false, child: child)),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        )
                      ],
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25.0)),
                      color: realColor),
                )),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons,
              ),
            )
          ],
        ));
  }
}
