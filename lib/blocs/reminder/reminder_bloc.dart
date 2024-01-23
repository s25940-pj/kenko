import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kenko/models/models.dart';
import 'package:kenko/repositories/reminder/reminder_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  }
}




