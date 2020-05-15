import 'package:FoodWatch/page_template.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'buttons.dart';
import 'colors.dart';

const _padding = EdgeInsets.all(16);
const _itemDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25.0),
      topRight: Radius.circular(25.0),
      bottomLeft: Radius.circular(25.0),
      bottomRight: Radius.circular(25.0),
    ),
    color: ItemActualColor.white);
const _divider = const Divider(
  color: Colors.transparent,
  height: 16,
);
const _fontWeightText = FontWeight.w300;
const _fontWeightTitles = FontWeight.w500;

class NewItemPage extends StatelessWidget {
  final Function back;

  const NewItemPage(
    this.back, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
          color: ItemColor.grey,
          buttons: [
            PageButton("Cancel", isRed: true, onPressed: () => {back()}),
            PageButton(
              "Save",
              onPressed: () => {},
            )
          ],
          child: Column(
            children: <Widget>[
              TitleInput(),
              _divider,
              ExpirationInput(),
              _divider,
              DescriptionInput(),
              _divider,
              PhotoButton(
                onPressed: () => {},
              )
            ],
          )),
    );
  }
}

class TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _padding,
        decoration: _itemDecoration,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Title",
                style: TextStyle(fontSize: 25, fontWeight: _fontWeightTitles),
              ),
              _divider,
              TextField(
                cursorColor: ItemActualColor.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemActualColor.darkGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemActualColor.blue),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  border: InputBorder.none,
                  hintText: "eg. Milk",
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
                ),
                style: TextStyle(fontSize: 30, fontWeight: _fontWeightText),
              )
            ]));
  }
}

class DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _padding,
        decoration: _itemDecoration,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Description",
                style: TextStyle(fontSize: 25, fontWeight: _fontWeightTitles),
              ),
              _divider,
              TextField(
//                expands: true,
                minLines: 2,
                maxLines: 8,
//                maxLines:10,
                cursorColor: ItemActualColor.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemActualColor.darkGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemActualColor.blue),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  border: InputBorder.none,
                  hintText: "eg. Organic Milk from costco, 3 containers",
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
                ),
                style: TextStyle(fontSize: 25, fontWeight: _fontWeightText),
              )
            ]));
  }
}

class ExpirationInput extends StatelessWidget {
  final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _padding,
        decoration: _itemDecoration,
        child: Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expiration",
                    style:
                        TextStyle(fontSize: 25, fontWeight: _fontWeightTitles),
                  ),
                  _divider,
                  Text(DateFormat('MMM d, yyyy').format(date),
                      style:
                          TextStyle(fontSize: 30, fontWeight: _fontWeightText))
                ])));
  }
}
