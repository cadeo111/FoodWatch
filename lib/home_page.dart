import 'package:FoodWatch/page_template.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        buttons: [
          PageButton("New Item", onPressed: () => {}),
        ],
        child: Stack(
          children: <Widget>[
            ListView.separated(
              padding: EdgeInsets.only(top: 100),
              itemBuilder: (BuildContext context, int index) {
                return ListItem();
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.transparent,
                height: 16,
              ),
              itemCount: 10,
            ),
            CustomSearchBar()
          ],
        ),
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 7), // changes position of shadow
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: Color(0xffF2F2F2),
      ),
      height: 80,
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 5.0, 5.0),
      alignment: Alignment.center,
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, size: 42),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
        ),
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class YearPill extends StatelessWidget {
  final bool bold;
  final bool white;

  const YearPill({Key key, this.bold = false, this.white = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    Color borderColor;
    if (bold) {
      if (white) {
        bgColor = Colors.white;
        borderColor = Colors.white;
        textColor = Colors.black;
      } else {
        bgColor = Colors.black;
        borderColor = Colors.black;
        textColor = Colors.white;
      }
    } else {
      if (white) {
        bgColor = Colors.transparent;
        borderColor = Colors.white;
        textColor = Colors.white;
      } else {
        bgColor = Colors.transparent;
        borderColor = Colors.black;
        textColor = Colors.black;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: bgColor),
      child: Text(
        '2020',
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w200, color: textColor),
      ),
    );
  }
}

class ListItem extends StatelessWidget {

  final ItemColor color;
  final bool boldYear;

  const ListItem(
      {Key key, this.color = ItemColor.grey, this.boldYear = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = bgColors[color];
    Color fontColor = fontColors[color.index];
    Widget pill;
    if (fontColor == Colors.white) {
      if (this.boldYear) {
        pill = YearPill(white: true, bold: true);
      } else {
        pill = YearPill(white: true);
      }
    } else {
      if (this.boldYear) {
        pill = YearPill(bold: true);
      } else {
        pill = YearPill();
      }
    }

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: bgColor),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Milk",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: fontColor),
              ),
              Text("Aug 24",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w200,
                      color: fontColor)),
              pill
            ]));
//    return ListTile(
//        leading: Text("Milk"), title: Text("Aug 24"), trailing: Text("2020"));
  }
}
