import 'package:flutter/material.dart';

import 'model/ItemsModel.dart';

class ItemColor {
  static const white = Color(0xffffffff);
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

// colors
// expired = red
// expires in 3 days = orange
// expires in 7 days = yellow

DateTime clearTime(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
}


Color getColorFromDate(DateTime expiration) {
  if (isDateExpired(expiration)) {
    return ItemColor.red;
  } else if (expiration.difference(DateTime.now()).inDays <= 3) {
    return ItemColor.orange;
  } else if (expiration.difference(DateTime.now()).inDays <= 7) {
    return ItemColor.yellow;
  } else {
    return ItemColor.grey;
  }
}
