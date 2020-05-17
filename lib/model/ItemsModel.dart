import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';

var _uuid = Uuid();

isDateExpired(DateTime expiration) =>
    expiration.difference(DateTime.now()).inDays <= 0 &&
    expiration.day != DateTime.now().day + 1;

class Item {
  final String _title; //todo make sure < 13 char long
  final DateTime expiration;
  final String _desc; //todo make sure < 300 char long
  final String id;
  final File img;
  static get maxTitleChars => 13;
  static get maxDescChars => 300;

  get color {
    return getColorFromDate(expiration);
  }

  get title => _title;

  get desc => _desc;

  get isExpired => isDateExpired(this.expiration);

  Item(
      {@required String title,
      @required this.expiration,
      String desc,
      this.img})
      : this._desc = desc,
        this._title = title,
        this.id = _uuid.v1();

  bool operator ==(other) => other is Item && id == other.id;

  @override
  int get hashCode => int.parse(id.substring(0, 8), radix: 16);

  @override
  String toString() {
    return 'Item{_title: $_title, expiration: $expiration, _desc: $_desc, id: $id, img: $img}';
  }


}

class ItemsModel extends Model {
  final Map<String, Item> _items =
      new Map(); // most recent is the bottom of the list

  ItemsModel({List<Item> items = const <Item>[]}) {
    items.forEach((i) {
      this._items[i.id] = i;
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
  }

  static ItemsModel of(BuildContext context) =>
      ScopedModel.of<ItemsModel>(context);
}
