library notifications;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/time/times.dart';

import 'package:gauthsy/kernel/event_manager/event_manager.dart' as EM;
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/models/notification.dart' as Model;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gauthsy/views/starting/starting.dart';

part 'local_notifications.dart';

part 'firebase_notifications.dart';

class NotificationManager {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  static EM.EventManager get em =>
      Kernel.Container().get<EM.EventManager>("em");

  static void init() {
    em.attach("authenticated", (_) async {
      initOnlyLocalNotification();
      new FirebaseNotifications().setUpFirebase();
    });
  }

  static Future showNotification(
      {@required int id,
      @required String title,
      @required String content,
      String payload}) async {

    flutterLocalNotificationsPlugin.show(
        id,
        title,
        content,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel1',
            'textChannel',
            'use to broadcast messages with texts',
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'app_icon',
          ),
        ), payload: payload);
  }

  static Future showBigTextNotification(
      {int id,
      String title,
      String content,
      String summaryText,
      String payload}) async {
    var bigTextStyleInformation = new BigTextStyleInformation(content,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: summaryText,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel2',
        'bigTextChannel',
        'use to broadcast messages with long texts',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails();
    await flutterLocalNotificationsPlugin
        .show(id, title, content, platformChannelSpecifics, payload: payload);
  }

  static Future cancelNotification({int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future onSelectNotification(String payload) async {
    print(payload);
    AuthManager.navigate(() {
      UrlParser.resolve(payload);
    });
  }

  static Future showIndeterminateProgressNotification(
      {int id, String title, String content}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel4',
        'indeterminateProgressPhannel',
        'use to show indeterminate progress bar',
        channelShowBadge: false,
        importance: Importance.high,
        priority: Priority.high,
        onlyAlertOnce: true,
        enableVibration: true,
        showProgress: true,
        indeterminate: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      content,
      platformChannelSpecifics,
    );
  }

  static Future scheduleNotification(
      {@required int id,
      @required DateTime dateTime,
      @required String title,
      @required String body,
      String payload}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel5',
        'scheduleNotifChannel',
        'use to broadcast schedule messages');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails();
    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, dateTime, platformChannelSpecifics,
        payload: payload);
  }

  static Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: Kernel.Container().get<BuildContext>('ctx'),
      builder: (BuildContext context) => new AlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          NeumorphicButton(
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              onSelectNotification(payload);
            },
          )
        ],
      ),
    );
  }

  static void initOnlyLocalNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );
  }

}