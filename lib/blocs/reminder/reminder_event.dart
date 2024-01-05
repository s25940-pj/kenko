part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class LoadReminders extends ReminderEvent {}

class UpdateReminders extends ReminderEvent {
  final List<Reminder> reminders;

  const UpdateReminders(this.reminders);

  @override
  List<Object> get props => [reminders];
}
