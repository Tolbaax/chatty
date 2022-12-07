import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static String serverKey =
      "AAAAh3bZ-J4:APA91bGT2F1HavsWAJUrOBtazuYAxq0glO9xToWkzeEZzFs27LgYMyymeuUSF9NSWaZVzcgM-PPSlgFPxHjh64G-pDv41g0cTANT1oMdAu9easrQNerugzQThyIqkniKKePzaQm7kaqH";

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      Random random = Random();
      int id = random.nextInt(1000);
      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "mychanel",
          "my chanel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      await flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  static Future<void> sendNotification(
      {String? title, String? message, String? token}) async {
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "message": message,
    };
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": "$token",
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Done');
        } else {
          if (kDebugMode) {
            print(response.statusCode.toString());
          }
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  static storeToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'fcmToken': token!}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
