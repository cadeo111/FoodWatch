import 'dart:collection';

import 'package:FoodWatch/detail_page.dart';
import 'package:FoodWatch/model/ItemModel.dart';
import 'package:FoodWatch/new_item_page.dart';
import 'package:FoodWatch/page_template.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'buttons.dart';
import 'colors.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        buttons: [
          OpenContainer(
              closedColor: Colors.white,
              openColor: ItemColor.grey,
              closedElevation: 0,
              openElevation: 15.0,
              openShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              transitionType: ContainerTransitionType.fade,
              transitionDuration: const Duration(milliseconds: 700),
              openBuilder: (context, action) {
                return NewItemPage(action);
              },
              closedBuilder: (context, action) {
                return DummyPageButton("New Item");
              })
        ],
        child: Stack(
          children: <Widget>[
            ScopedModelDescendant<ItemsModel>(builder: _listOfItems),
            CustomSearchBar()
          ],
        ),
      ),
    );
  }
}

ListView _listOfItems(
    BuildContext context, Widget child, ItemsModel itemsModel) {
  UnmodifiableListView<Item> items = itemsModel.items;
  return ListView.separated(
    padding: EdgeInsets.only(top: 100),
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      Item item = items[index];
      return ListItem(item: item);
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(
      color: Colors.transparent,
      height: 16,
    ),
  );
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

class YearPill extends StatelessWidget {
  final bool bold;
  final bool white;
  final int year;

  const YearPill(this.year, {Key key, this.bold = false, this.white = false})
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
        year.toString(),
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w200, color: textColor),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Item item;
  const ListItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String monthDay = (new DateFormat('MMMd')).format(item.expiration);
    Color color = getColorFromDate(item.expiration);
    Color bgColor = color;
    Color fontColor = ItemColor.getFontColor(color);

    int year = item.expiration.year;
    bool boldYear = item.expiration.difference(DateTime.now()).inDays > 365;
    Widget pill;
    if (fontColor == Colors.white) {
      if (boldYear) {
        pill = YearPill(year, white: true, bold: true);
      } else {
        pill = YearPill(year, white: true);
      }
    } else {
      if (boldYear) {
        pill = YearPill(year, bold: true);
      } else {
        pill = YearPill(year);
      }
    }

    return OpenContainer(
      closedElevation: 0,
      openElevation: 15.0,
      openColor: bgColor,
      closedColor: bgColor,
      openShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      transitionDuration: const Duration(milliseconds: 700),
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (BuildContext context, void Function() action) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: bgColor),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                  child:Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        color: fontColor),
                  )),
                  (boldYear)?pill:Text(monthDay,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w200,
                          color: fontColor))
                ]));
      },
      openBuilder: (BuildContext context, void Function() action) {
        return DetailPage(
          item:item,
          close:action,
        );
      },
    );
  }
}
