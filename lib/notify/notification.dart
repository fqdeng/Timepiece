
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void startNotificationService() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {}

Future<void> showNotification(String title, String context) async {
  NotificationDetails? notificationDetails;
  if (Platform.isAndroid) {
    var androidDetails = const AndroidNotificationDetails(
      'timepiece_channel_id',
      'Clock',
      channelDescription: 'Time is up',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    notificationDetails = NotificationDetails(android: androidDetails);
  }

  if (Platform.isIOS) {
    var iOSDetails = const DarwinNotificationDetails(presentSound: true);
    notificationDetails = NotificationDetails(iOS: iOSDetails);
  }

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    context,
    notificationDetails,
  );
}