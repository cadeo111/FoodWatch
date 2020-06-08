import 'package:FoodWatch/model/ItemsModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ScopedModel<ItemsModel>(
    model: ItemsModel.fromStorage(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}
