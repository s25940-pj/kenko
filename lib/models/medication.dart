import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:kenko/enums/enums.dart';
import 'package:kenko/enums/medication_dosage_unit.dart';

class Medication extends Equatable {
  final String id;
  final String name;
  final String company;
  final MedicationType type;
  final MedicationDosageUnit dosageUnit;

  const Medication(
      {required this.name,
      required this.company,
      required this.id,
      required this.type,
      required this.dosageUnit});

  @override
  List<Object> get props => [name, company];

  @override
  String toString() => 'Medication { name: $name, company: $company }';

  static Medication fromSnapshot(DocumentSnapshot snap) {
    return Medication(
      name: snap['name'],
      company: snap['company'],
      id: snap.id,
      type: MedicationType.values.firstWhere(
          (element) => element.toString() == 'MedicationType.${snap['type']}'),
      dosageUnit: MedicationDosageUnit.values.firstWhere((element) =>
          element.toString() == 'MedicationDosageUnit.${snap['dosageUnit']}'),
    );
  }
}
