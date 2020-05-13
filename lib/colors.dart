import 'package:flutter/material.dart';

enum ItemColor { white, grey, yellow, orange, red }
class ItemActualColor{
  static const white= Color(0xffffffff);
  static const grey=  Color(0xffF2F2F2);
  static const yellow= Color(0xffF3E37C);
  static const orange= Color(0xffF2994A);
  static const red= Color(0xffEF6F6C);
}

 const Map<ItemColor, Color> bgColors = const {
  ItemColor.white:ItemActualColor.white,
  ItemColor.grey: ItemActualColor.grey,
  ItemColor.yellow: ItemActualColor.yellow,
  ItemColor.orange: ItemActualColor.orange,
  ItemColor.red: ItemActualColor.red,
};

const Map<ItemColor, Color> fontColors = const {
  ItemColor.white: Colors.black,
  ItemColor.grey: Colors.black,
  ItemColor.yellow: Colors.black,
  ItemColor.orange: Colors.white,
  ItemColor.red: Colors.white,
};
