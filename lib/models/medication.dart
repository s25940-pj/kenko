import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Medication extends Equatable {
  final String id;
  final String name;
  final String company;

  const Medication(
      {required this.name, required this.company, required this.id});

  @override
  List<Object> get props => [name, company];

  @override
  String toString() => 'Medication { name: $name, company: $company }';

  static Medication fromSnapshot(DocumentSnapshot snap) {
    return Medication(
      name: snap['name'],
      company: snap['company'],
      id: snap.id,
    );
  }
}
