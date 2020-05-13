import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: DetailPage(),
    );
  }
}
