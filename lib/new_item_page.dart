import 'dart:io';
import 'dart:math';

import 'package:FoodWatch/page_template.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'buttons.dart';
import 'colors.dart';
import 'detail_page.dart';
import 'model/ItemsModel.dart';
import 'notifications.dart';

const _padding = EdgeInsets.all(16);
const _itemDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25.0),
      topRight: Radius.circular(25.0),
      bottomLeft: Radius.circular(25.0),
      bottomRight: Radius.circular(25.0),
    ),
    color: ItemColor.white);
const _divider = const Divider(
  color: Colors.transparent,
  height: 16,
);
const _fontWeightText = FontWeight.w300;
const _fontWeightTitles = FontWeight.w500;

copyImageToAppStorage(File imageFile) async {
  //from https://stackoverflow.com/questions/51338041/how-to-save-image-file-in-flutter-file-selected-using-image-picker-plugin
  // getting a directory path for saving
  final String path = (await getApplicationDocumentsDirectory()).path;
// copy the file to a new path
  String rand = (Random().nextDouble() * 1e10).toInt().toRadixString(16);
  final File newImage = await imageFile.copy(join(path, 'PIC_$rand.png'));
  return newImage;
}

class NewItemPage extends StatefulWidget {
  final Function back;

  const NewItemPage(
    this.back, {
    Key key,
  }) : super(key: key);

  @override
  _NewItemPageState createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  String _title;
  String _desc;
  DateTime _expiration = clearTime(DateTime.now().add(Duration(days: 1)));
  File _img;

  bool _isSaveButtonDisabled() {
    return !(_title != null && _expiration != clearTime(DateTime.now()));
  }

  setTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  setDesc(String desc) {
    setState(() {
      _desc = desc;
    });
  }

  setExpiration(DateTime expiration) {
    if (expiration != null) {
      setState(() {
        _expiration = expiration;
      });
    }
  }

  createNewItem(BuildContext context) async {
    File savedImageFile;
    if (_img != null) {
      savedImageFile = await copyImageToAppStorage(_img);
    }
    Item item = Item(
        title: _title,
        expiration: _expiration,
        desc: _desc,
        img: savedImageFile);
    showNotification(
        dateToShow: DateTime.now(), daysToExpire: 3, nameOfItem: _title);
    ItemsModel.of(context).add(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
          color: getColorFromDate(_expiration),
          buttons: [
            PageButton("Cancel", isRed: true, onPressed: () {
              widget.back();
            }),
            PageButton(
              "Save",
              disabled: _isSaveButtonDisabled(),
              onPressed: () async {
                await createNewItem(context);
                widget.back();
              },
            )
          ],
          child: ListView(
            shrinkWrap: false,
            children: <Widget>[
              TitleInput(onChangeText: (String input) {
                setTitle(input);
              }),
              _divider,
              ExpirationInput(_expiration, onDateChanged: (DateTime dt) {
                setExpiration(dt);
              }),
              _divider,
              DescriptionInput(onChangeText: (String input) {
                setDesc(input);
              }),
              _divider,
              photoSlot(context, _img, (File f) {
                setState(() {
                  _img = f;
                });
              }, BorderRadius.all(Radius.circular(30)),
                  BorderRadius.all(Radius.circular(22)))
            ],
          )),
    );
  }
}

class TitleInput extends StatelessWidget {
  final void Function(String input) onChangeText;

  TitleInput({this.onChangeText});

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
                maxLength: Item.maxTitleChars,
                onChanged: onChangeText,
                cursorColor: ItemColor.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemColor.darkGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemColor.blue),
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
  final void Function(String input) onChangeText;

  DescriptionInput({this.onChangeText});

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
                maxLength: Item.maxDescChars,
                onChanged: onChangeText,
                minLines: 2,
                maxLines: 8,
                cursorColor: ItemColor.blue,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemColor.darkGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: ItemColor.blue),
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
  final DateTime date;
  final void Function(DateTime dt) onDateChanged;

  const ExpirationInput(this.date, {Key key, this.onDateChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDateModal(context, init: date).then((DateTime dt) {
            onDateChanged(dt);
          });
        },
        child: Container(
            padding: _padding,
            decoration: _itemDecoration,
            child: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Expiration",
                        style: TextStyle(
                            fontSize: 25, fontWeight: _fontWeightTitles),
                      ),
                      _divider,
                      Text(DateFormat('MMM d, yyyy').format(date),
                          style: TextStyle(
                              fontSize: 30, fontWeight: _fontWeightText))
                    ]))));
  }
}

Widget photoSlot(BuildContext context, File imgFile, setImageFile(File f),
    BorderRadius containerRadius, BorderRadius imgRadius) {
  if (imgFile != null) {
    Image img = Image.file(imgFile);
    return GestureDetector(
        onTap: () {
          showPhotoDialog(context, setImageFile, title: "Change Photo",
              onDelete: () {
            setImageFile(null);
          });
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: containerRadius,
                border: Border.all(color: Colors.white, width: 8)),
            child: ClipRRect(borderRadius: imgRadius, child: img)));
  } else {
    return PhotoButton(
        onPressed: () =>
            showPhotoDialog(context, setImageFile, title: "Set Photo"));
  }
}
