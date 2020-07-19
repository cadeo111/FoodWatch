import 'dart:collection';
import 'dart:io';

import 'package:FoodWatch/detail_page.dart';
import 'package:FoodWatch/model/ItemsModel.dart';
import 'package:FoodWatch/new_item_page.dart';
import 'package:FoodWatch/page_template.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'buttons.dart';
import 'colors.dart';
import 'custom_dismissable.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchStr = "";

  void setSearchStr(String str) => setState(() {
        searchStr = str;
      });

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ItemsModel>(
        builder: (BuildContext context, Widget child, ItemsModel model) {
      final List<Item> items =
          UnmodifiableListView(model.items.where((Item item) {
        final inDesc = item.desc?.contains(searchStr) ?? false;
        final inTitle = item.title.contains(searchStr);
        final inDateStr = DateFormat('EEEE MMMM d yyyy')
            .format(item.expiration)
            .contains(searchStr);
        return inTitle || inDateStr || inDesc;
      }));
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageTemplate(
          buttons: [
            OpenContainer(
                closedColor: (isDarkmode(context))
                    ? ItemColorDark.buttonOnDarkGrey
                    : ItemColor.white,
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
                transitionDuration: const Duration(milliseconds: 400),
                openBuilder: (context, action) {
                  return NewItemPage(action);
                },
                closedBuilder: (context, action) {
                  return DummyPageButton("New Item");
                })
          ],
          child: Stack(
            children: <Widget>[
              _listOfItems(context, items),
              CustomSearchBar(
                setSearchStr: setSearchStr,
              )
            ],
          ),
        ),
      );
    });
  }
}

ListView _listOfItems(BuildContext context, UnmodifiableListView<Item> items) {
  final padding = Platform.isAndroid
      ? EdgeInsets.only(top: 108, bottom: 16)
      : EdgeInsets.only(top: 100);
  return ListView.separated(
    padding: padding,
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

class CustomSearchBar extends StatefulWidget {
  final void Function(String str) setSearchStr;

  @override
  const CustomSearchBar({Key key, @required this.setSearchStr})
      : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState(setSearchStr);
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final void Function(String str) setSearchStr;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  _CustomSearchBarState(this.setSearchStr) {
    controller = TextEditingController(text: "");
    controller.addListener(() {
      setSearchStr(controller.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final margin = Platform.isAndroid ? EdgeInsets.only(top: 12) : null;
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
        color:
            (isDarkmode(context)) ? ItemColorDark.darkDarkGrey : ItemColor.grey,
      ),
      margin: margin,
      height: 80,
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 5.0, 5.0),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, size: 42),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
        ),
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w300,
            color: (isDarkmode(context)) ? ItemColorDark.white : null),
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
        bgColor = (isDarkmode(context)) ? ItemColorDark.white : ItemColor.white;
        borderColor = (isDarkmode(context))
            ? ItemColorDark.fontColorGrey
            : ItemColor.white;
        textColor =
            (isDarkmode(context)) ? ItemColorDark.black : ItemColor.black;
      } else {
        bgColor = (isDarkmode(context)) ? ItemColorDark.black : ItemColor.black;
        borderColor =
            (isDarkmode(context)) ? ItemColorDark.black : ItemColor.black;
        textColor = (isDarkmode(context))
            ? ItemColorDark.fontColorGrey
            : ItemColor.white;
      }
    } else {
      if (white) {
        bgColor = Colors.transparent;
        borderColor = (isDarkmode(context))
            ? ItemColorDark.fontColorGrey
            : ItemColor.white;
        textColor = (isDarkmode(context))
            ? ItemColorDark.fontColorGrey
            : ItemColor.white;
      } else {
        bgColor = Colors.transparent;
        borderColor =
            (isDarkmode(context)) ? ItemColorDark.black : ItemColor.black;
        textColor =
            (isDarkmode(context)) ? ItemColorDark.black : ItemColor.black;
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
    Color color =
        getColorFromDate(item.expiration, darkMode: isDarkmode(context));
    Color bgColor = color;
    Color fontColor = (isDarkmode(context))
        ? ItemColorDark.getFontColor(color)
        : ItemColor.getFontColor(color);

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

    return CustomDismissible(
        onDismissed: (direction) {
          ItemsModel.of(context).delete(item);
        },
        direction: DismissDirection.endToStart,
        background: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(15.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (isDarkmode(context)) ? ItemColorDark.red : ItemColor.red,
                ),
                child: Icon(
                  Icons.delete,
                  color: (isDarkmode(context))
                      ? ItemColorDark.fontColorGrey
                      : ItemColor.white,
                  size: 36.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ))
          ],
        ),
        key: Key(item.id),
        child: OpenContainer(
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
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    color: bgColor),
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          flex: 1,
                          child: Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                color: fontColor),
                          )),
                      (boldYear)
                          ? pill
                          : Text(monthDay,
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w200,
                                  color: fontColor))
                    ]));
          },
          openBuilder: (BuildContext context, void Function() action) {
            return DetailPage(
              item: item,
              close: action,
            );
          },
        ));
  }
}
