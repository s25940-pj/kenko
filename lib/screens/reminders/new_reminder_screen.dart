import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenko/blocs/blocs.dart';
import 'package:kenko/enums/medication_dosage_unit.dart';
import 'package:kenko/models/models.dart';
import 'package:kenko/repositories/repositories.dart';
import 'package:kenko/widgets/widgets.dart';
import 'package:uuid/uuid.dart';
import '../../api/notification_api.dart';

import '../../enums/enums.dart';

class NewReminderScreen extends StatefulWidget {
  const NewReminderScreen({super.key});

  static const routeName = '/reminders/new-reminder';

  @override
  State<NewReminderScreen> createState() => _NewReminderScreenState();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const NewReminderScreen(),
    );
  }
}

class _NewReminderScreenState extends State<NewReminderScreen> {
  final TextEditingController selectedMedicationNameController =
      TextEditingController();
  final TextEditingController selectedMedicationDosageController =
      TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));
  String selectedMedicationDosageUnitName = MedicationDosageUnit.units.name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KenkoAppBar(
        title: 'New Reminder',
      ),
      body: Form(
        key: _formKey,
        child: BlocBuilder<MedicationBloc, MedicationState>(
          builder: (context, state) {
            if (state is MedicationLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is MedicationsLoadSuccess) {
              selectedMedicationNameController.text =
                  _getMedicationNames(state.medications).first;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      DropdownMenu<String>(
                        initialSelection:
                            _getMedicationNames(state.medications).first,
                        controller: selectedMedicationNameController,
                        requestFocusOnTap: true,
                        label: const Text('Medication'),
                        onSelected: (String? medicationName) {
                          setState(() {
                            if (medicationName != null) {
                              selectedMedicationNameController.text =
                                  medicationName;
                              selectedMedicationDosageUnitName =
                                  getMedicationDosageUnitByMedicationType(
                                          getMedicationTypeByMedicationName(
                                              state.medications,
                                              selectedMedicationNameController
                                                  .text))
                                      .name;
                            }
                          });
                        },
                        dropdownMenuEntries: _getMedicationNames(
                                state.medications)
                            .map<DropdownMenuEntry<String>>(
                                (medicationName) => DropdownMenuEntry<String>(
                                      value: medicationName,
                                      label: medicationName,
                                      enabled: medicationName != 'Grey',
                                      style: MenuItemButton.styleFrom(
                                        foregroundColor: Colors.green,
                                      ),
                                    ))
                            .toList(),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                              initialEntryMode: TimePickerEntryMode.dial);
                          if (timeOfDay != null) {
                            setState(() {
                              selectedTime = timeOfDay;
                            });
                          }
                        },
                        child: const Text('Select Time'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTimeRange? dateTimeRange =
                              await showDateRangePicker(
                                  context: context,
                                  initialDateRange: selectedDateRange,
                                  firstDate: DateTime(DateTime.now().year, 1),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 1));
                          if (dateTimeRange != null) {
                            setState(() {
                              selectedDateRange = dateTimeRange;
                            });
                          }
                        },
                        child: const Text('Select Date'),
                      ),
                      TextFormField(
                        controller: selectedMedicationDosageController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText:
                              'Enter dosage in $selectedMedicationDosageUnitName',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter dosage';
                          } else if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      BlocProvider(
                        create: (context) => ReminderBloc(
                            reminderRepository: ReminderRepository()),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String? result = await showDialog<String>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Reminder'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Do you want to create a reminder for this medication?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (result == 'Cancel') {
                                return;
                              }

                              NotificationApi
                                  .scheduleMultipleNotificationsAtDateTimeRange(
                                dateRange: selectedDateRange,
                                selectedTime: selectedTime,
                                medicationName:
                                    selectedMedicationNameController.text,
                                dosage: int.parse(
                                    selectedMedicationDosageController.text),
                              );

                              var reminder = Reminder(
                                id: const Uuid().v4(),
                                medicationId: _getMedicationIdFromName(
                                    state.medications,
                                    selectedMedicationNameController.text),
                                time: selectedTime,
                                dateTimeRange: selectedDateRange,
                                dosage: int.parse(
                                    selectedMedicationDosageController.text),
                              );
                              context.read<ReminderBloc>().add(
                                    AddReminder(reminder),
                                  );
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Add Reminder',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
          },
        ),
      ),
    );
  }

  List<String> _getMedicationNames(List<Medication> medications) {
    List<String> medicationNames = [];
    for (var medication in medications) {
      medicationNames.add(medication.name);
    }
    return medicationNames;
  }

  String _getMedicationIdFromName(
      List<Medication> medications, String? medicationName) {
    for (var medication in medications) {
      if (medication.name == medicationName) {
        return medication.id;
      }
    }
    return "";
  }

  MedicationType getMedicationTypeByMedicationName(
      List<Medication> medications, String medicationName) {
    for (var medication in medications) {
      if (medication.name == medicationName) {
        return medication.type;
      }
    }
    return MedicationType.tablet;
  }

  MedicationDosageUnit getMedicationDosageUnitByMedicationType(
      MedicationType medicationType) {
    switch (medicationType) {
      case MedicationType.syrup:
        return MedicationDosageUnit.ml;
      case MedicationType.tablet:
        return MedicationDosageUnit.units;
      default:
        return MedicationDosageUnit.units;
    }
  }
}
