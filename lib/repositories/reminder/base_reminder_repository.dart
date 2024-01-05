import 'package:kenko/models/models.dart';

abstract class BaseReminderRepository {
  Stream<List<Reminder>> getReminders();
}
