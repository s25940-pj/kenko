import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kenko/models/medication.dart';
import 'package:kenko/repositories/medication/medication_repository.dart';

part 'medication_event.dart';
part 'medication_state.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final MedicationRepository _medicationRepository;
  StreamSubscription? _medicationsSubscription;

  MedicationBloc({required MedicationRepository medicationRepository})
      : _medicationRepository = medicationRepository,
        super(MedicationLoadInProgress()) {
    on<LoadMedications>(_onLoadMedications);
    on<UpdateMedications>(_onUpdateMedications);
  }

  void _onLoadMedications(
      LoadMedications event, Emitter<MedicationState> emit) {
    _medicationsSubscription?.cancel();
    _medicationsSubscription = _medicationRepository.getMedications().listen(
          (medications) => add(UpdateMedications(medications)),
        );
  }

  void _onUpdateMedications(
      UpdateMedications event, Emitter<MedicationState> emit) {
    emit(MedicationsLoadSuccess(medications: event.medications));
  }
}
