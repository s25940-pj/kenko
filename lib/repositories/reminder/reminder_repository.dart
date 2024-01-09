import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kenko/models/reminder.dart';
import 'package:kenko/repositories/reminder/base_reminder_repository.dart';

class ReminderRepository extends BaseReminderRepository {
  final FirebaseFirestore _firebaseFirestore;

  ReminderRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Reminder>> getReminders() {
    return _firebaseFirestore.collection('reminders').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Reminder.fromSnapshot(doc)).toList());
  }

  @override
  Future<void> addNewReminder(Reminder reminder) {
    return _firebaseFirestore
        .collection('reminders')
        .add(reminder.toDocument());
  }
}
