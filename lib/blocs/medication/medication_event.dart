part of 'medication_bloc.dart';

sealed class MedicationEvent extends Equatable {
  const MedicationEvent();

  @override
  List<Object> get props => [];
}

class LoadMedications extends MedicationEvent {}

class UpdateMedications extends MedicationEvent {
  final List<Medication> medications;

  const UpdateMedications(this.medications);

  @override
  List<Object> get props => [medications];
}
