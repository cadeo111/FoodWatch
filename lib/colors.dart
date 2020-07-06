import 'package:flutter/material.dart';

import 'model/ItemsModel.dart';

class ItemColor {
  static const black = Colors.black;
  static const white = Colors.white;
  static const grey = Color(0xffF2F2F2);
  static const darkGrey = Color(0xffBDBDBD);
  static const yellow = Color(0xffF3E37C);
  static const orange = Color(0xffF2994A);
  static const red = Color(0xffEF6F6C);
  static const periwinkle = Color(0xFF92AAFF);
  static const blue = Color(0xff3EC6FF);

  static Color getFontColor(Color c) {
    if (c == ItemColor.orange || c == ItemColor.red) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}

class ItemColorDark {
  static const black = Color(0xff121212);
  static const darkDarkGrey = Color(0xff414141);
  static const darkGrey = Color(0xff666666);
  static const grey = Color(0xff646464);
  static const yellow = Color(0xffAC8601);
  static const orange = Color(0xffA94F00);
  static const red = Color(0xff760300);
  static const blue = Color(0xff3EC6FF);
  static const buttonOnDarkGrey = Color(0xff718DEF);
  static const buttonOnBlack = Color(0xff6C87E4);
  static const buttonSecondaryOnDarkGrey = Color(0xffD96663);
//  static const buttonSecondaryOnDarkGrey = Color(0xffE18583);
  static const fontColorGrey = Color(0xffcccccc);
  static const white = Colors.white;

  static Color getFontColor(Color c) {
    if (c == ItemColorDark.buttonOnDarkGrey) {
      return ItemColorDark.white;
    }
    return ItemColorDark.fontColorGrey;
  }
}

bool isDarkmode(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark;
//  return true;
}

// colors
// expired = red
// expires in 3 days = orange
// expires in 7 days = yellow

DateTime clearTime(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
}

Color getColorFromDate(DateTime expiration, {bool darkMode = false}) {
  if (isDateExpired(expiration)) {
    if (darkMode) {
      return ItemColorDark.red;
    } else {
      return ItemColor.red;
    }
  } else if (expiration.difference(DateTime.now()).inDays <= 3) {
    if (darkMode) {
      return ItemColorDark.orange;
    } else {
      return ItemColor.orange;
    }
  } else if (expiration.difference(DateTime.now()).inDays <= 7) {
    if (darkMode) {
      return ItemColorDark.yellow;
    } else {
      return ItemColor.yellow;
    }
  } else {
    if (darkMode) {
      return ItemColorDark.grey;
    } else {
      return ItemColor.grey;
    }
  }
}
