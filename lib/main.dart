import 'dart:math';

import 'package:FoodWatch/model/ItemsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void _requestIOSPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

void _configureDidReceiveLocalNotificationSubject(
    BuildContext context, Route<Object> Function(String payload) getRoute) {
  didReceiveLocalNotificationSubject.stream
      .listen((ReceivedNotification receivedNotification) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null
            ? Text(receivedNotification.title)
            : null,
        content: receivedNotification.body != null
            ? Text(receivedNotification.body)
            : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                getRoute(receivedNotification.payload),
//              );
            },
          )
        ],
      ),
    );
  });
}

void _configureSelectNotificationSubject(
    BuildContext context, Route<Object> Function(String payload) getRoute) {
  selectNotificationSubject.stream.listen((String payload) async {
//    await Navigator.push(context, getRoute(payload));
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// flutter notification init
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

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
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject(context,
        (payload) => MaterialPageRoute(builder: (context) => HomePage()));
    _configureSelectNotificationSubject(context,
        (payload) => MaterialPageRoute(builder: (context) => HomePage()));
  }

  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }
}

Future<void> scheduleNotification(
    {DateTime dateToShow, String nameOfItem, int daysToExpire}) async {
  final DateTime now = dateToShow;
  final scheduledNotificationDateTime =
      DateTime(now.year, now.month, now.day, 9);
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'expirationAlerts',
      'Expiration Alerts',
      'Lets you know when your food is close to expiring');
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  final rng = new Random();
  final id = rng.nextInt(100);
  await flutterLocalNotificationsPlugin.schedule(
      id,
      '$nameOfItem expires in $daysToExpire days',
      null,
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

Future<void> showNotification(
    {@required DateTime dateToShow,
    @required String nameOfItem,
    @required int daysToExpire}) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'expirationAlerts',
      'Expiration Alerts',
      'Lets you know when your food is close to expiring');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  final rng = new Random();
  final id = rng.nextInt(100);
  await flutterLocalNotificationsPlugin.show(
      id,
      '$nameOfItem expires in $daysToExpire days',
      null,
      platformChannelSpecifics);
}
