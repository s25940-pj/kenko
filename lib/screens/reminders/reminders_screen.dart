import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenko/blocs/blocs.dart';
import 'package:kenko/models/models.dart';
import 'package:kenko/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/enums.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  static const String routeName = '/reminders';

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const RemindersScreen(),
    );
  }

  static IconData getIconByMedicationType(MedicationType type) {
    switch (type) {
      case MedicationType.tablet:
        return Icons.medication;
      case MedicationType.syrup:
        return Icons.medication_liquid;
      default:
        return Icons.medication;
    }
  }
}

class _RemindersScreenState extends State<RemindersScreen> {
  String userId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KenkoAppBar(title: 'Reminders'),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state is RemindersLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RemindersLoadSuccess) {
            fetchUserIdFromSharedPreferences();

            List<Reminder> reminders = List.empty(growable: true);
            if (userId != '') {
              reminders = state.reminders
                  .where((reminder) => reminder.userId == userId)
                  .toList();

              if (reminders.isEmpty) {
                return const Center(
                  child: Text('You have no reminders'),
                );
              }
            }

            if (reminders.isEmpty) {
              return const Center(
                child: Text('Log in to see your reminders'),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.reminders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _reminderCard(
                          context,
                          reminders[index],
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Text('Something went wrong!');
          }
        },
      ),
      bottomNavigationBar: const KenkoNavBar(),
      floatingActionButton:
          const AddNewItemButton(routeName: '/reminders/new-reminder'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Card _reminderCard(
    BuildContext context,
    Reminder reminder,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<MedicationBloc, MedicationState>(
          builder: (context, state) {
            if (state is MedicationsLoadSuccess) {
              final medication = state.medications.firstWhere(
                (medication) => medication.id == reminder.medicationId,
              );
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    medication.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(RemindersScreen.getIconByMedicationType(medication.type),
                      size: 18),
                  Text(
                    reminder.time.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            } else {
              return const Text('Something went wrong!');
            }
          },
        ),
      ),
    );
  }

  Future<void> fetchUserIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserId = prefs.getString('userId') ?? '';
    print('Stored userId from SharedPreferences: $storedUserId');
    setState(() {
      userId = storedUserId;
    });
  }
}
