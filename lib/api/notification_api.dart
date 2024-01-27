import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import '../screens/reminders/new_reminder_screen.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<NotificationDetails> _notificationDetails() async {
    try {
      return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails(),
      );
    } catch (e) {
      print('Error creating notification details: $e');
      rethrow;
    }
  }

  static Future init({bool initSheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {},
    );
  }

  static Future<void> scheduleMultipleNotificationsAtDateTimeRange({
    required DateTimeRange dateRange,
    required TimeOfDay selectedTime,
    required String medicationName,
    required int dosage,
  }) async {
    final DateTime startDate = dateRange.start;
    final DateTime endDate = dateRange.end;
    final int numberOfDays = endDate.difference(startDate).inDays;

    for (int i = 0; i <= numberOfDays; i++) {
      final DateTime currentDate = startDate.add(Duration(days: i));
      scheduleNotificationAtDateTime(
        selectedDate: currentDate,
        selectedTime: selectedTime,
        medicationName: medicationName,
        dosage: dosage,
      );
    }
  }

  static Future<void> scheduleNotificationAtDateTime({
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required String medicationName,
    required int dosage,
  }) async {
    final int notificationId = DateTime.now().microsecondsSinceEpoch % 1000000;
    final String notificationTitle = 'Take your $medicationName';
    final String notificationBody = 'Take $dosage of $medicationName';
    const String notificationPayload = 'Reminder Payload';

    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    try {
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
