import 'dart:io' show Platform;
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  FirebaseMessagingService();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static int i = 0;

  void configLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          // this is for iphone usings ios under 10

          // didReceiveLocalNotificationSubject.add(ReceivedNotification(
          //     id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        // clicking on the notif callback
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  void configFirebaseNotification() {
    //print('configuring FIREBASE MESSAGING');

    configLocalNotification();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // if (i % 2 == 0) {
        // print("onMessage called: $message");
        showNotification(message);

        // something else you wanna execute
        // }
        // i++;
        // return;
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showNotification(message);
      },
      //onBackgroundMessage: showNotification,
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showNotification(message);
      },
    );

    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String newToken) {
      print('************user token*************');
      print(newToken);
    });
  }

  Future<void> showNotification(Map<String, dynamic> message) async {
    int id = Random().nextInt(1000);
    print('called with $id');
    //print(message);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.kwexpress.app' : 'com.kwexpress.app.ios2',
      'KW express',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      message['notification']['title'].toString(),
      message['notification']['body'].toString(),
      platformChannelSpecifics,
    );
  }
}
