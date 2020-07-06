import 'package:FoodWatch/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescButton extends NewItemPropButton {
  DescButton({Key key, @required onPressed})
      : super("Add Description", onPressed: onPressed, key: key);
}

class PhotoButton extends NewItemPropButton {
  PhotoButton({Key key, @required onPressed})
      : super("Add Photo", onPressed: onPressed, key: key);
}

class NewItemPropButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  NewItemPropButton(
    this.text, {
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkmode(context)
        ? ItemColorDark.buttonOnBlack
        : ItemColor.periwinkle;
    Color textColor =
        isDarkmode(context) ? ItemColorDark.white : ItemColor.white;

    return SizedBox(
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: bgColor,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          onPressed: onPressed,
          child: Text(text,
              style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w300)),
        ),
        width: double.infinity);
  }
}

class PageButton extends StatelessWidget {
  final String text;
  final bool isRed;
  final Function onPressed;
  final bool disabled;

  PageButton(this.text,
      {Key key,
      this.isRed = false,
      @required Function onPressed,
      this.disabled: false})
      : this.onPressed = (disabled) ? null : onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color disabledBgColor;
    Color disabledTextColor;
    Color textColor;
    if (isDarkmode(context)) {
      bgColor = (isRed)
          ? ItemColorDark.buttonSecondaryOnDarkGrey
          : ItemColorDark.buttonOnDarkGrey;
      textColor = Colors.white;
      disabledTextColor = textColor;
      disabledBgColor = ItemColorDark.darkDarkGrey;
    } else {
      textColor = (isRed) ? Color(0xffFF8F8C) : Color(0xff92AAFF);
      bgColor = Colors.white;
      disabledTextColor = ItemColor.darkGrey;
      disabledBgColor = bgColor;
    }
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: bgColor,
      disabledColor: disabledBgColor,
      disabledTextColor: disabledTextColor,
      textColor: textColor,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      onPressed: onPressed,
      child: Text(text,
          style: TextStyle(
              fontSize: 28, fontFamily: "Roboto", fontWeight: FontWeight.w300)),
    );
  }
}

class PhotoSelectionButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  PhotoSelectionButton(this.text, {Key key, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkmode(context)
        ? ItemColorDark.buttonOnDarkGrey
        : ItemColor.periwinkle;
    Color textColor = Colors.white;

    return SizedBox(
        width: double.infinity,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: bgColor,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          onPressed: onPressed,
          child: Text(text,
              style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w300)),
        ));
  }
}

class SmallerOutlinedButton extends StatelessWidget {
  final String text;
  final bool isRed;
  final Function onPressed;
  final bool disabled;

  SmallerOutlinedButton(this.text,
      {Key key, this.isRed = false, @required onPressed, this.disabled = false})
      : this.onPressed = (disabled) ? null : onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;
    if (isDarkmode(context)) {
      bgColor = (isRed)
          ? ItemColorDark.buttonSecondaryOnDarkGrey
          : ItemColorDark.buttonOnDarkGrey;
      textColor = ItemColorDark.white;
      borderColor = bgColor;
    } else {
      bgColor = ItemColor.white;
      textColor = (isRed) ? Color(0xffFF8F8C) : Color(0xff92AAFF);
      borderColor = (disabled) ? ItemColor.darkGrey : textColor;
    }

    return FlatButton(
      disabledTextColor: ItemColor.darkGrey,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1.0, color: borderColor),
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: bgColor,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      onPressed: onPressed,
      child: Text(text,
          style: TextStyle(
              fontSize: 20, fontFamily: "Roboto", fontWeight: FontWeight.w300)),
    );
  }
}

class DummyPageButton extends StatelessWidget {
  final String text;

  DummyPageButton(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = (isDarkmode(context))
        ? ItemColorDark.buttonOnDarkGrey
        : ItemColor.white;

    Color textColor;
    if (isDarkmode(context)) {
      textColor = ItemColorDark.getFontColor(ItemColorDark.buttonOnDarkGrey);
    } else {
      textColor = ItemColor.periwinkle;
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Text(text,
          style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w300)),
    );
  }
}
