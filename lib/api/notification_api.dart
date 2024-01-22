import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import '../screens/reminders/new_reminder_screen.dart';



class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

static Future<NotificationDetails> _notificationDetails() async {
  return NotificationDetails(
    android: AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
    ),
    iOS: IOSNotificationDetails(),
  );
}

  static Future init({bool initSheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {},
    );
  }

  static Future<void> scheduleNotificationAtTime({
    required TimeOfDay timeOfDay,
    required String medicationName,
    required int dosage,
  }) async {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    final int notificationId = now.microsecondsSinceEpoch % 1000000;
    final String notificationTitle = 'Take your $medicationName';
    final String notificationBody = 'Take $dosage of $medicationName';
    final String notificationPayload = 'Reminder Payload';

    print('Notification ID: $notificationId');
    print('Notification Title: $notificationTitle');
    print('Notification Body: $notificationBody');
    print('Selected DateTime: $selectedDateTime');
    try{ 
    await _notifications.zonedSchedule(
      notificationId,
      notificationTitle,
      notificationBody,
      tz.TZDateTime.from(selectedDateTime, tz.local),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      payload: notificationPayload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('Notification scheduled successfully!');
    } catch (e, stackTrace) {
  print('Error scheduling notification: $e');
  print('Stack trace: $stackTrace');
}
  }


}
