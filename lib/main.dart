import 'dart:math';

import 'package:FoodWatch/model/ItemsModel.dart';
import 'package:FoodWatch/new_item_page.dart';
import 'package:flutter/material.dart';
import 'package:mock_data/mock_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'detail_page.dart';
import 'home_page.dart';






final items = ItemsModel(items: [
  for (var i = 0; i < 10; i++)
    Item(
        title: mockString(Random().nextInt(12)+1, 'aA'),
        expiration:mockDate(DateTime.now().subtract(Duration(days: 4)), DateTime.now().add(Duration(days: 10))),
        desc: mockString(Random().nextInt(300)+1, 'aA')),
  for (var i = 0; i < 10; i++)
    Item(
        title: mockString(Random().nextInt(12)+1, 'a#'),
        expiration:mockDate(DateTime.now().add(Duration(days:365)), DateTime.now().add(Duration(days: 375))),
        desc: mockString(Random().nextInt(300)+1, 'aA'))
]);

void main() => runApp(ScopedModel<ItemsModel>(
      model: items,
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}
