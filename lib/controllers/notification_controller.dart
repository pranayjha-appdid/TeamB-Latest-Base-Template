import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController implements GetxService {
  String? savedFcmToken;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> notificationInitMethod() async {
    await requestNotificationPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      log(fcmToken, name: "FCM TOKEN");
      savedFcmToken = fcmToken;
      update();
      log(fcmToken, name: "FCM TOKEN");
    }
    await initializeNotifications();
    await initializeFirebaseMessaging();
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    log('Notification permission status: $status', name: 'Permission');
  }

  RemoteMessage? _pendingInitialMessage;

  RemoteMessage? get pendingInitialMessage => _pendingInitialMessage;

  void updatePendingMessage(RemoteMessage? pendingmessage) {
    _pendingInitialMessage = pendingmessage;
    update();
  }

  Future<void> initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App opened from terminated state with data: ${message.data}', name: 'FCM');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          updatePendingMessage(message);
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground notification received: ${message.toMap().toString()}', name: 'FCM');
      Timer.run(() {
        handleForgroundmessage(message);
      });
      if (Platform.isAndroid) {
        showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification opened: ${message.notification?.apple?.sound?.name}', name: 'FCM');
      handleMessageNavigation(message);
    });
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification tap on iOS/Android
        log("Notification tapped with payload: ${notificationResponse.payload}", name: "LocalNotification");

        if (notificationResponse.payload != null) {
          final Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);

          handleMessageNavigation(RemoteMessage(data: data));
        }
      },
    );
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails('channel_id', 'channel_name', importance: Importance.high, priority: Priority.high);

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final Map<String, dynamic> payload = Map<String, dynamic>.from(message.data);

    if (message.notification?.title != null) {
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformDetails, payload: jsonEncode(payload));
    }
  }

  void handleMessageNavigation(RemoteMessage message) {
    log(message.toMap().toString(), name: "Message");
  }

  bool isIncomingCallScreenOpen = false;
  Future<void> handleForgroundmessage(RemoteMessage message) async {
    log(message.data["type"].toString(), name: "Type");
  }
}
