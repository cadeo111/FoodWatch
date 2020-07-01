import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';

var _uuid = Uuid();

int getNotificationId() {
  final rng = new Random();
  return rng.nextInt(10000) * 10;
}

isDateExpired(DateTime expiration) =>
    expiration.difference(DateTime.now()).inDays <= 0 &&
    expiration.day != DateTime.now().day + 1;

Future<Database> openMyDB() async {
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'items_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE IF NOT EXISTS items("
        "id TEXT PRIMARY KEY, "
        "title TEXT,"
        "desc TEXT, "
        "notificationId INT, "
        "expirationAsIso8601 TEXT, "
        "imgPath TEXT"
        " )",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

final Future<Database> database = openMyDB();

class Item {
  final String title; //todo make sure < 13 char long
  final DateTime expiration;
  final String desc; //todo make sure < 300 char long
  final String id;
  final int notificationId;
  final File img;

  static get maxTitleChars => 13;

  static get maxDescChars => 300;

  get color {
    return getColorFromDate(expiration);
  }

  get isExpired => isDateExpired(this.expiration);

  Item({@required this.title, @required this.expiration, this.desc, this.img})
      : this.id = _uuid.v1(),
        this.notificationId = getNotificationId();

  Item.withId(
      {this.notificationId,
      this.title,
      this.expiration,
      this.desc,
      this.id,
      this.img});

  Item.fromMap(Map<String, dynamic> m)
      : this.title = m['title'],
        this.notificationId = m['notificationId'],
        this.expiration = DateTime.parse(m['expirationAsIso8601']),
        this.desc = m['desc'],
        this.id = m['id'],
        this.img = (m['imgPath'] == null) ? null : File(m['imgPath']);

  bool operator ==(other) => other is Item && id == other.id;

  @override
  int get hashCode => int.parse(id.substring(0, 8), radix: 16);

  @override
  String toString() {
    return 'Item{_title: $title, expiration: $expiration, _desc: $desc, id: $id, img: $img}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> m = new Map();
    m['title'] = title;
    m['notificationId'] = notificationId;
    m['expirationAsIso8601'] = expiration.toIso8601String();
    m['desc'] = desc;
    m['id'] = id;
    m['imgPath'] = img?.path;
    developer.log(m['imgPath'], name: "path");
    return m;
  }

  Future<void> insertInDB() async {
    // Get a reference to the database.
    final Database db = await database;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'items',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateInDb() async {
    // Get a reference to the database.
    final db = await database;
    // Update the given Dog.
    await db.update(
      'items',
      this.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [this.id],
    );
  }

  Future<void> deleteInDb() async {
    // Get a reference to the database.
    final db = await database;
    // Remove the Dog from the Database.
    await db.delete(
      'items',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [this.id],
    );
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

  Future<List<Item>> getItemsFromDb() async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('items');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  ItemsModel.fromStorage() {
    getItemsFromDb().then((list) {
      list.forEach((item) {
        _items[item.id] = item;
      });
      notifyListeners();
    });
  }

  UnmodifiableListView<Item> get items {
    List<Item> list = _items.values.toList();
    list.sort((a, b) => a.expiration.compareTo(b.expiration));
    return UnmodifiableListView(list);
  }

  void add(Item item) {
    _items[item.id] = item;
    item.insertInDB();
    notifyListeners();
  }

  void update(Item updated) {
    _items[updated.id] = updated;
    updated.updateInDb();
    notifyListeners();
  }

  void delete(Item deleted) {
    _items.remove(deleted.id);
    deleted.deleteInDb();
    notifyListeners();
  }

  static ItemsModel of(BuildContext context) =>
      ScopedModel.of<ItemsModel>(context);
}
