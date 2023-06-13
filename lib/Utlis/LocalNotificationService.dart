import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../controllers/DashboardController.dart';
import '../routes/Routes.dart';

class LocalNotificationService {
  static final onNotifications = BehaviorSubject<String?>();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final initializationSettingsAndroid = new AndroidInitializationSettings('drawable/app_icon');
    final initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
          Map<String, dynamic> messageData = jsonDecode(payload!);
          print(messageData);
          Get.toNamed(Routes.CHAT_SCREEN);
        });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'default_notification_channel_id',
          'default_notification_channel_id channel',
          playSound: true,
          enableVibration: true,
          importance: Importance.max,
          icon: "app_icon",
          priority: Priority.high);
      var notificationDetails = new NotificationDetails(android: androidPlatformChannelSpecifics);
      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: jsonEncode(message.data));

      Get.put(DashboardController());
      Get.find<DashboardController>().showMsgPop.value = true;

    } on Exception catch (e) {
      print(e);
    }
  }

}
