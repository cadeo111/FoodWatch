import 'dart:collection';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';

var _uuid = Uuid();

isDateExpired(DateTime expiration) =>
    expiration.difference(DateTime.now()).inDays <= 0 &&
    expiration.day != DateTime.now().day + 1;

class Item {
  final String title; //todo make sure < 13 char long
  final DateTime expiration;
  final String desc; //todo make sure < 300 char long
  final String id;
  final File img;

  static get maxTitleChars => 13;

  static get maxDescChars => 300;

  get color {
    return getColorFromDate(expiration);
  }

  get isExpired => isDateExpired(this.expiration);

  Item({@required this.title, @required this.expiration, this.desc, this.img})
      : this.id = _uuid.v1();

  Item.withId({this.title, this.expiration, this.desc, this.id, this.img});

  Item.fromMap(Map<String, dynamic> m)
      : this.title = m['title'],
        this.expiration = m['expiration'],
        this.desc = m['desc'],
        this.id = m['id'],
        this.img = (m['imgUri'] == null) ? null : File.fromUri(m['imgUri']);

  bool operator ==(other) => other is Item && id == other.id;

  @override
  int get hashCode => int.parse(id.substring(0, 8), radix: 16);

  @override
  String toString() {
    return 'Item{_title: $title, expiration: $expiration, _desc: $desc, id: $id, img: $img}';
  }

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['title'] = title;
    m['expiration'] = expiration;
    m['desc'] = desc;
    m['id'] = id;
    m['imgUri'] = img?.uri;
    return m;
  }
}

class ItemsModel extends Model {
  final Map<String, Item> _items =
      new Map(); // most recent is the bottom of the list
  final LocalStorage storage = new LocalStorage('foodwatch');

  ItemsModel({List<Item> items = const <Item>[]}) {
    items.forEach((i) {
      this._items[i.id] = i;
    });
  }

  ItemsModel.fromStorage() {
    Map<String, dynamic> items = storage.getItem('items');
    items?.forEach((key, value) {
      this._items[key] = value;
    });
  }

  UnmodifiableListView<Item> get items {
    List<Item> list = _items.values.toList();
    list.sort((a, b) => a.expiration.compareTo(b.expiration));
    return UnmodifiableListView(list);
  }

  void add(Item item) {
    _items[item.id] = item;
    notifyListeners();
    _saveModel();
  }

  void update(Item updated) {
    _items[updated.id] = updated;
    notifyListeners();
    _saveModel();
  }

  static ItemsModel of(BuildContext context) =>
      ScopedModel.of<ItemsModel>(context);

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    this._items.forEach((key, value) {
      m[key] = value.toJSONEncodable();
    });
    return m;
  }

  void _saveModel() {
    storage.setItem("items", this.toJSONEncodable());
  }
}
