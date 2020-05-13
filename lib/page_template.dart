import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatelessWidget {
  final List<PageButton> buttons;
  final Widget child;

  const PageTemplate({Key key, @required this.buttons, @required this.child})
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
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(25.0)),
                    color: Colors.white),
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

class PageButton extends StatelessWidget {
  final String text;
  final bool isRed;

  final Function onPressed;

  PageButton(this.text, {Key key, this.isRed = false, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      onPressed: () => {},
      child: Text(text,
          style: TextStyle(
              color: (isRed) ? Color(0xffFF8F8C) : Color(0xff92AAFF),
              fontSize: 28,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300)),
    );
  }
}
