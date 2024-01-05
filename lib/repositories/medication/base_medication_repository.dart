import 'package:kenko/models/models.dart';

abstract class BaseMedicationRepository {
  Stream<List<Medication>> getMedications();
}
