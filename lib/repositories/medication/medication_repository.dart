import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kenko/models/medication.dart';
import 'package:kenko/repositories/medication/base_medication_repository.dart';

class MedicationRepository extends BaseMedicationRepository {
  final FirebaseFirestore _firebaseFirestore;

  MedicationRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Medication>> getMedications() {
    return _firebaseFirestore.collection('medications').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Medication.fromSnapshot(doc)).toList());
  }
}
