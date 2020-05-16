import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:FoodWatch/colors.dart';
import 'package:FoodWatch/page_template.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'buttons.dart';
import 'model/ItemModel.dart';

const _padding = EdgeInsets.all(16);
const _borderRadius = BorderRadius.only(
  topLeft: Radius.circular(0.0),
  topRight: Radius.circular(25.0),
  bottomLeft: Radius.circular(25.0),
  bottomRight: Radius.circular(25.0),
);
const _itemDecoration =
    BoxDecoration(borderRadius: _borderRadius, color: ItemColor.white);

class DetailPage extends StatefulWidget {
  const DetailPage({@required this.close, Key key, this.item})
      : super(key: key);
  final Item item;
  final Function close;

  @override
  _DetailPageState createState() => _DetailPageState(item, close);
}

class _DetailPageState extends State<DetailPage> {
  final Item item;
  final Function close;

  _DetailPageState(this.item, this.close);

  File _imgFile;

  void _setImageFile(File f) {
    setState(() {
      _imgFile = f;
    });
  }

  Widget _photoSlot(BuildContext context) {
    if (_imgFile != null) {
      Image img = Image.file(_imgFile);
      return GestureDetector(
          onLongPress: () {
            _showPhotoDialog(context, _setImageFile, title: "Change Photo");
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: _borderRadius,
                  border: Border.all(color: Colors.white, width: 8)),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(19.0),
                    bottomLeft: Radius.circular(19.0),
                    bottomRight: Radius.circular(19.0),
                  ),
                  child: img)));
    } else {
      return PhotoButton(
          onPressed: () =>
              _showPhotoDialog(context, _setImageFile, title: "Set Photo"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        color: item.color,
        buttons: [
          PageButton("Home", onPressed: () {
            close();
          }),
        ],
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            GestureDetector(
                onLongPress: () {
                  _showTitleDialog(context);
                },
                child: Row(children: <Widget>[
                  Text(item.title,
                      style: TextStyle(fontSize: 40, color: ItemColor.getFontColor(item.color)))
                ])),
            const Divider(
              color: Colors.transparent,
              height: 8,
            ),
            GestureDetector(
                onLongPress: () => {
                      _showDateModal(context)
                          .then((value) => log(value.toIso8601String()))
                    },
                child: Container(
                  padding: _padding,
                  decoration: _itemDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text((item.isExpired)?"Expired ":"Expires ",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500)),
                      Text(DateFormat("MMM d, yyyy").format(item.expiration),//"Jan 12, 2020"
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300))
                    ],
                  ),
                )),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
            GestureDetector(
                onLongPress: () {
                  _showDescriptionDialog(context);
                },
                child: Container(
                    padding: _padding,
                    decoration: _itemDecoration,
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                        item.desc,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300)))),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
            _photoSlot(context)
          ],
        ),
      ),
    );
  }
}

const _divider = const Divider(
  color: Colors.transparent,
  height: 16,
);

const _fontWeightText = FontWeight.w300;

Future<void> _showDescriptionDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SimpleDialog(
              contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              titlePadding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              title: Text('Description'),
              children: <Widget>[
                TextField(
//                expands: true,
                  minLines: 2,
                  maxLines: 8,
//                maxLines:10,
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
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(142, 142, 147, 1)),
                  ),
                  style: TextStyle(fontSize: 20, fontWeight: _fontWeightText),
                ),
                _divider,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SmallerOutlinedButton("Cancel",
                        isRed: true, onPressed: () {}),
                    SmallerOutlinedButton("Save", onPressed: () {}),
                  ],
                )
              ]));
    },
  );
}

Future<void> _showTitleDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SimpleDialog(
              contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              titlePadding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              title: Text('Title'),
              children: <Widget>[
                TextField(
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
                    hintStyle: const TextStyle(
                        color: Color.fromRGBO(142, 142, 147, 1)),
                  ),
                  style: TextStyle(fontSize: 20, fontWeight: _fontWeightText),
                ),
                _divider,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SmallerOutlinedButton("Cancel",
                        isRed: true, onPressed: () {}),
                    SmallerOutlinedButton("Save", onPressed: () {}),
                  ],
                )
              ]));
    },
  );
}

Future<DateTime> _showDateModal(BuildContext context, {DateTime init}) async {
  DateTime date = init == null ? DateTime.now() : init;
  var pressedDone = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SizedBox(
          height: 240.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(249, 249, 247, 1.0),
                  border: Border(
                    bottom: const BorderSide(width: 0.5, color: Colors.black38),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {
                  date = value;
                },
                backgroundColor: Colors.white,
              )),
            ],
          ),
        )),
//    filter: filter,
//    useRootNavigator: useRootNavigator,
//    semanticsDismissible: semanticsDismissible,
  );
  if (pressedDone != null && init != null) {
    return init;
  } else {
    return date;
  }
}

class PhotoChild extends StatefulWidget {
  final Function(File f) onPhotoSet;
  final String title;

  PhotoChild(this.onPhotoSet, this.title);

  @override
  _PhotoChildState createState() => _PhotoChildState(onPhotoSet, title);
}

class _PhotoChildState extends State<PhotoChild> {
  File _imgFile;
  final Function(File f) onPhotoSet;
  final String title;

  _PhotoChildState(this.onPhotoSet, this.title);

  void setImageFile(File f) {
    setState(() {
      _imgFile = f;
    });
  }

  Future<void> setImageFromGallery() async {
    setImageFile(await ImagePicker.pickImage(source: ImageSource.gallery));
  }

  Future<void> setImageFromCamera() async {
    setImageFile(await ImagePicker.pickImage(source: ImageSource.camera));
  }

  List<Widget> _childrenWithoutImage() {
    return <Widget>[
      PhotoSelectionButton("Take Photo ", onPressed: () {
        setImageFromCamera();
      }),
      _divider,
      PhotoSelectionButton("From Gallery", onPressed: () {
        setImageFromGallery();
      }),
      _divider,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SmallerOutlinedButton("Cancel", isRed: true, onPressed: () {
            Navigator.pop(context);
          }),
        ],
      ),
    ];
  }

  List<Widget> _childrenWithImage(File file) {
    log(file?.path);
    return <Widget>[
      Image.file(file),
      _divider,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SmallerOutlinedButton("Cancel", isRed: true, onPressed: () {
            Navigator.pop(context);
          }),
          SmallerOutlinedButton("Save", onPressed: () {
            onPhotoSet(_imgFile);
            Navigator.pop(context);
          }),
        ],
      ),
    ];
  }

  List<Widget> getChildren() {
    return (_imgFile == null)
        ? _childrenWithoutImage()
        : _childrenWithImage(_imgFile);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        titlePadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        title: Text(title),
        children: getChildren());
  }
}

Future<void> _showPhotoDialog(BuildContext context, Function(File f) onPhotoSet,
    {String title}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: PhotoChild(onPhotoSet, title));
    },
  );
}
