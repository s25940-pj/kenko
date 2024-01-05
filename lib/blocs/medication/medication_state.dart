part of 'medication_bloc.dart';

sealed class MedicationState extends Equatable {
  const MedicationState();

  @override
  List<Object> get props => [];
}

class MedicationLoadInProgress extends MedicationState {}

class MedicationsLoadSuccess extends MedicationState {
  final List<Medication> medications;

  const MedicationsLoadSuccess({this.medications = const <Medication>[]});

  @override
  List<Object> get props => [medications];
}
