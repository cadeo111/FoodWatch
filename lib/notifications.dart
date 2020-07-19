import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'model/ItemsModel.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

//put this in main after WidgetsFlutterBinding.ensureInitialized();
Future<void> initializeNotifications() async {
  // flutter notification init
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');
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
}

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

void requestIOSPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

void configureDidReceiveLocalNotificationSubject(
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

void configureSelectNotificationSubject(
    BuildContext context, Route<Object> Function(String payload) getRoute) {
  selectNotificationSubject.stream.listen((String payload) async {
//    await Navigator.push(context, getRoute(payload));
  });
}

Future<void> scheduleNotification(
    {@required int id,
    @required DateTime dateToShow,
    @required String nameOfItem,
    @required int daysToExpire}) async {
  final DateTime now = dateToShow;
  final scheduledNotificationDateTime =
      DateTime(now.year, now.month, now.day, 9);
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'expirationAlerts',
      'Expiration Alerts',
      'Lets you know when your food is close to expiring',
      priority: Priority.Default);
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      id,
      (daysToExpire != 0)
          ? '$nameOfItem expires in $daysToExpire days'
          : "$nameOfItem expires today",
      null,
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

Future<void> createNotificationsForItem(Item i) async {
  final int notifId = i.notificationId;
  final DateTime expiration = i.expiration;
  final name = i.title;

  final DateTime day7expiration = expiration.subtract(Duration(days: 7));
  final DateTime day3expiration = expiration.subtract(Duration(days: 3));

  final DateTime timeToShow = DateTime(0, 0, 0, 8, 30);

  final DateTime day7Full = DateTime(day7expiration.year, day7expiration.month,
      day7expiration.day, timeToShow.hour, timeToShow.minute);
  final DateTime day3Full = DateTime(day3expiration.year, day3expiration.month,
      day3expiration.day, timeToShow.hour, timeToShow.minute);
  final DateTime dayOfFull = DateTime(expiration.year, expiration.month,
      expiration.day, timeToShow.hour, timeToShow.minute);

  final DateTime now = DateTime.now();

  //7 day notification
  if (now.isBefore(day7Full)) {
    await scheduleNotification(
        id: notifId + 1,
        dateToShow: day7Full,
        nameOfItem: name,
        daysToExpire: 7);
  }

  //3 day notification
  if (now.isBefore(day3Full)) {
    await scheduleNotification(
        id: notifId + 2,
        dateToShow: day3Full,
        nameOfItem: name,
        daysToExpire: 3);
  }

  //day of expiration notification
  if (now.isBefore(dayOfFull)) {
    await scheduleNotification(
        id: notifId + 3,
        dateToShow: dayOfFull,
        nameOfItem: name,
        daysToExpire: 0);
  }
}

Future<void> deleteNotificationsForItem(Item i) async {
  final int notifId = i.notificationId;
  // cancel 7 day notification
  await flutterLocalNotificationsPlugin.cancel(notifId + 1);
  // cancel 3 day notification
  await flutterLocalNotificationsPlugin.cancel(notifId + 2);
  // cancel day of notification
  await flutterLocalNotificationsPlugin.cancel(notifId + 3);
}

Future<void> updateNotificationsForItem(Item i) async {
  await deleteNotificationsForItem(i);
  await createNotificationsForItem(i);
}
