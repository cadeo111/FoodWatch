import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:FoodWatch/colors.dart';
import 'package:FoodWatch/page_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'buttons.dart';
import 'model/ItemsModel.dart';
import 'new_item_page.dart';
import 'package:collection/collection.dart';

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
  _DetailPageState createState() => _DetailPageState(item);
}

class _DetailPageState extends State<DetailPage> {
  _DetailPageState(Item item) {
    _desc = item.desc;
    _title = item.title;
    _expiration = item.expiration;
    _img = item.img;
    _itemImgBytes = item?.img?.readAsBytesSync();
  }

  File _img;
  Uint8List _itemImgBytes;
  bool _imageChanged = false;
  bool _imgSame = true;
  String _desc;
  String _title;
  DateTime _expiration;

  _updateItem(BuildContext context) async {
    File savedImageFile = widget.item.img;
    if (_img != null && _img != savedImageFile) {
      savedImageFile = await copyImageToAppStorage(_img);
    }
    Item item = Item.withId(
        id: widget.item.id,
        title: _title,
        expiration: _expiration,
        desc: _desc,
        img: savedImageFile);
    ItemsModel.of(context).update(item);
  }

  void setImgSame(bool b) {
    setState(() {
      _imgSame = b;
    });
  }

  void setImgChanged(bool b) {
    setState(() {
      _imageChanged = b;
    });
  }

  void updateImageSame() async {
    if (_imageChanged) {
      if (widget.item.img == _img) {
        setImgSame(true);
      } else if (_img == null) {
        setImgSame(false);
      } else {
        final Uint8List imgBytes = await _img.readAsBytes();
        setImgSame(ListEquality().equals(imgBytes, _itemImgBytes));
      }
      setImgChanged(false);
    }
  }

  bool _itemNeedsUpdating() {
    return (!_imgSame) ||
        (_desc != widget.item.desc) ||
        (_title != widget.item.title) ||
        (_expiration != widget.item.expiration);
  }

  void _setImageFile(File f) {
    setState(() {
      _img = f;
      updateImageSame();
    });
  }

  void _setDesc(String s) {
    setState(() {
      _desc = s == "" ? null : s;
    });
  }

  void _setTitle(String s) {
    setState(() {
      _title = s == "" ? widget.item.title : s;
    });
  }

  void _setExpiration(DateTime dt) {
    setState(() {
      _expiration = dt;
    });
  }

  Widget _getDesc(BuildContext context) {
    if (_desc != null) {
      return GestureDetector(
          onLongPress: () async {
            String desc = await _showDescriptionDialog(context, init: _desc);
            _setDesc(desc);
          },
          child: Container(
              padding: _padding,
              decoration: _itemDecoration,
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Text(_desc,
                  style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w300))));
    } else {
      return DescButton(onPressed: () async {
        String desc = await _showDescriptionDialog(context);
        _setDesc(desc);
      });
    }
  }

  List<Widget> _getButtons() {
    if (_itemNeedsUpdating()) {
      return [
        PageButton("Cancel", isRed: true, onPressed: () {
          widget.close();
        }),
        PageButton(
          "Save",
          onPressed: () async {
            await _updateItem(context);
            widget.close();
          },
        )
      ];
    } else {
      return [
        PageButton("Home", onPressed: () {
          widget.close();
        }),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTemplate(
        color: getColorFromDate(_expiration),
        buttons: _getButtons(),
        child: ListView(
          shrinkWrap: false,
          children: <Widget>[
            GestureDetector(
                onLongPress: () async {
                  String title = await _showTitleDialog(context, init: _title);
                  if (title != null) {
                    _setTitle(title);
                  }
                },
                child: Row(children: <Widget>[
                  Flexible(
                      child: Text(_title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 40,
                              color:
                                  ItemColor.getFontColor(widget.item.color))))
                ])),
            const Divider(
              color: Colors.transparent,
              height: 8,
            ),
            GestureDetector(
                onLongPress: () async {
                  DateTime dt = await showDateModal(context, init: _expiration);
                  _setExpiration(dt);
                },
                child: Container(
                  padding: _padding,
                  decoration: _itemDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          (isDateExpired(_expiration))
                              ? "Expired "
                              : "Expires ",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500)),
                      Text(DateFormat("MMM d, yyyy").format(_expiration),
                          //"Jan 12, 2020"
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300))
                    ],
                  ),
                )),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
            _getDesc(context),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
            photoSlot(
                context,
                _img,
                _setImageFile,
                _borderRadius,
                BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(19.0),
                    bottomLeft: Radius.circular(19.0),
                    bottomRight: Radius.circular(19.0))),
            const Divider(
              color: Colors.transparent,
              height: 16,
            ),
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

Widget photoSlot(BuildContext context, File imgFile, setImageFile(File f),
    BorderRadius containerRadius, BorderRadius imgRadius) {
  if (imgFile != null) {
    Image img = Image.file(imgFile);
    return GestureDetector(
        onLongPress: () {
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

Future<String> _showDescriptionDialog(BuildContext context,
    {String init}) async {
  String str = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController controller =
          TextEditingController(text: init);
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
                  maxLength: Item.maxDescChars,
                  controller: controller,
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
                    SmallerOutlinedButton("Cancel", isRed: true, onPressed: () {
                      Navigator.pop(context, null);
                    }),
                    SmallerOutlinedButton("Save", onPressed: () {
                      Navigator.pop(context, controller.text);
                    }),
                  ],
                )
              ]));
    },
  );
  return str;
}

class _TitleDialogContent extends StatefulWidget {
  final String init;

  const _TitleDialogContent({Key key, this.init}) : super(key: key);

  @override
  __TitleDialogContentState createState() => __TitleDialogContentState(init);
}

class __TitleDialogContentState extends State<_TitleDialogContent> {
  TextEditingController controller;
  int inputLength;

  __TitleDialogContentState(String init) {
    controller = TextEditingController(text: init);
    inputLength = init?.length ?? 0;
    controller.addListener(() {
      setState(() {
        inputLength = controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                maxLength: Item.maxTitleChars,
                cursorColor: ItemColor.blue,
                controller: controller,
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
                style: TextStyle(fontSize: 20, fontWeight: _fontWeightText),
              ),
              _divider,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SmallerOutlinedButton("Cancel", isRed: true, onPressed: () {
                    Navigator.pop(context);
                  }),
                  SmallerOutlinedButton("Save", disabled: (inputLength <= 0),
                      onPressed: () {
                    Navigator.pop(context, controller.text);
                  }),
                ],
              )
            ]));
  }
}

Future<String> _showTitleDialog(BuildContext context, {String init}) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return _TitleDialogContent(init: init);
    },
  );
}

Future<DateTime> showDateModal(BuildContext context, {DateTime init}) async {
  DateTime placeholderDate = clearTime(DateTime.now().add(Duration(days: 1)));
  DateTime date = (init == null) ? placeholderDate : init;
  DateTime min;
  DateTime start;
  if (init == null) {
    min = placeholderDate;
    start = placeholderDate;
  } else if (init.difference(placeholderDate).inDays < 0) {
    min = init;
    start = init;
  } else {
    min = placeholderDate;
    start = init;
  }

  date = await showCupertinoModalPopup<DateTime>(
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
                          Navigator.of(context).pop(date);
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
                initialDateTime: start,
                minimumDate: min,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {
                  date = value;
                },
                backgroundColor: Colors.white,
              )),
            ],
          ),
        )),
  );

  return date;
}

class PhotoChild extends StatefulWidget {
  final Function(File f) onPhotoSet;
  final String title;
  final Function onDelete;

  PhotoChild(this.onPhotoSet, this.title, this.onDelete);

  @override
  _PhotoChildState createState() => _PhotoChildState();
}

class _PhotoChildState extends State<PhotoChild> {
  File _imgFile;

  _PhotoChildState();

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
      PhotoSelectionButton("Take Photo ", onPressed: () async {
        setImageFromCamera();
      }),
      _divider,
      PhotoSelectionButton("From Gallery", onPressed: () async {
        setImageFromGallery();
      }),
      _divider,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: (widget.onDelete != null)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: <Widget>[
          ...(widget.onDelete != null)
              ? [
                  SmallerOutlinedButton("Cancel", onPressed: () {
                    Navigator.pop(context);
                  }),
                  SmallerOutlinedButton("Delete", isRed: true, onPressed: () {
                    widget.onDelete();
                    Navigator.pop(context);
                  }),
                ]
              : [
                  SmallerOutlinedButton("Cancel", isRed: true, onPressed: () {
                    Navigator.pop(context);
                  })
                ]
        ],
      ),
    ];
  }

  List<Widget> _childrenWithImage(File file) {
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
            widget.onPhotoSet(_imgFile);
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
        title: Text(widget.title),
        children: getChildren());
  }
}

Future<void> showPhotoDialog(BuildContext context, Function(File f) onPhotoSet,
    {String title, Function onDelete}) async {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: PhotoChild(onPhotoSet, title, onDelete));
    },
  );
}
