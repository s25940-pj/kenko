part of 'reminder_bloc.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

class RemindersLoadInProgress extends ReminderState {}

class RemindersLoadSuccess extends ReminderState {
  final List<Reminder> reminders;

  const RemindersLoadSuccess({this.reminders = const <Reminder>[]});

  @override
  List<Object> get props => [reminders];
}
