import 'package:FoodWatch/model/ItemsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';
import 'notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeNotifications();

  runApp(ScopedModel<ItemsModel>(
    model: ItemsModel.fromStorage(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }

  void initState() {
    super.initState();
    requestIOSPermissions();
    configureDidReceiveLocalNotificationSubject(context,
        (payload) => MaterialPageRoute(builder: (context) => HomePage()));
    configureSelectNotificationSubject(context,
        (payload) => MaterialPageRoute(builder: (context) => HomePage()));
  }

  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }
}
