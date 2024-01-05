import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String medicationId;

  const Reminder({required this.id, required this.medicationId});

  @override
  List<Object> get props => [id, medicationId];

  static Reminder fromSnapshot(DocumentSnapshot snap) {
    return Reminder(
      id: snap.id,
      medicationId: snap['medicationId'],
    );
  }
}
