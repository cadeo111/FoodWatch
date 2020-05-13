import 'package:FoodWatch/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final List<PageButton> buttons;
  final Widget child;
  final ItemColor color;

  const PageTemplate(
      {Key key,
      @required this.buttons,
      @required this.child,
      this.color = ItemColor.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF92AAFF),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SafeArea(child: child)),
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
                    color: bgColors[color]),
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
      ),
    );
  }
}

class PhotoButton extends StatelessWidget {
  final Function onPressed;

  PhotoButton({Key key, @required this.onPressed}): super(key: key);
  @override
  Widget build(BuildContext context) {
    Color bgColor =   Color(0xff92AAFF);
    Color textColor = Colors.white;

    return SizedBox(child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: bgColor,

      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      onPressed: () => {},
      child: Text("Add Photo",
          style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300)),
    ), width: double.infinity);
  }

}

class PageButton extends StatelessWidget {
  final String text;
  final bool isRed;
  final Function onPressed;

  PageButton(this.text, {Key key, this.isRed = false, @required this.onPressed}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color textColor = (isRed) ? Color(0xffFF8F8C) : Color(0xff92AAFF);

    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: bgColor,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      onPressed: () => {},
      child: Text(text,
          style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300)),
    );
  }
}
