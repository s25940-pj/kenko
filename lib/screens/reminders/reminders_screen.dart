import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenko/blocs/blocs.dart';
import 'package:kenko/models/models.dart';
import 'package:kenko/widgets/widgets.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  static const String routeName = '/reminders';

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
                        state.reminders[index],
                      );
                    },
                  ),
                ],
              ),
            );
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<MedicationBloc, MedicationState>(
              builder: (context, state) {
                if (state is MedicationsLoadSuccess) {
                  final medication = state.medications.firstWhere(
                    (medication) => medication.id == reminder.medicationId,
                  );
                  return Text(
                    medication.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const Text('Something went wrong!');
                }
              },
            ),
            BlocBuilder<ReminderBloc, ReminderState>(
              builder: (context, state) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // context.read<ReminderBloc>().add(
                        //       UpdateReminder(
                        //         reminder.copyWith(isCompleted: true),
                        //       ),
                        //     );
                      },
                      icon: const Icon(Icons.add_task),
                    ),
                    IconButton(
                      onPressed: () {
                        // context.read<ReminderBloc>().add(
                        //       DeleteReminder(
                        //         reminder.copyWith(isCancelled: true),
                        //       ),
                        //     );
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const RemindersScreen(),
    );
  }
}
