import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kenko/models/models.dart';
import 'package:kenko/repositories/reminder/reminder_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository _reminderRepository;
  StreamSubscription? _remindersSubscription;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReminderBloc({required ReminderRepository reminderRepository})
      : _reminderRepository = reminderRepository,
        super(RemindersLoadInProgress()) {
    on<LoadReminders>(_onLoadReminders);
    on<UpdateReminders>(_onUpdateReminders);
    on<AddReminder>(_onAddReminder);
  }

  void _onLoadReminders(LoadReminders event, Emitter<ReminderState> emit) {
    _remindersSubscription?.cancel();
    _remindersSubscription = _reminderRepository.getReminders().listen(
      (reminders) => add(UpdateReminders(reminders)),
    );
  }

  void _onUpdateReminders(UpdateReminders event, Emitter<ReminderState> emit) {
    emit(RemindersLoadSuccess(reminders: event.reminders));
  }

  void _onAddReminder(AddReminder event, Emitter<ReminderState> emit) {
    _reminderRepository.addNewReminder(event.reminder);

    // Planowanie powiadomienia
    final tz.TZDateTime nextNotificationDateTime =
        _getNextNotificationDateTime(event.reminder.time);

    // Wywołanie funkcji do planowania powiadomienia
    _zonedScheduleAlarmClockNotification(nextNotificationDateTime);

    print('Powiadomienie zostało zaplanowane na: $nextNotificationDateTime');
  }

  Future<void> _zonedScheduleAlarmClockNotification(
      tz.TZDateTime scheduledDate) async {

        print('_zonedScheduleAlarmClockNotification');
    await flutterLocalNotificationsPlugin.zonedSchedule(
      123,
      'scheduled alarm clock title',
      'scheduled alarm clock body',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_clock_channel',
          'Alarm Clock Channel',
          channelDescription: 'Alarm Clock Notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _getNextNotificationDateTime(TimeOfDay timeOfDay) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime selectedDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (selectedDateTime.isBefore(now)) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    return selectedDateTime;
  }

  DateTime _getNextNotificationDateTimeLocal(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (selectedDateTime.isBefore(now)) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    return selectedDateTime;
  }
}
