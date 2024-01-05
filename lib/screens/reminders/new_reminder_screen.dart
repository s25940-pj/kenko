import 'package:flutter/material.dart';


class NewReminderScreen extends StatelessWidget {
  const NewReminderScreen({super.key});

  static const routeName = '/reminders/new-reminder';

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerId = TextEditingController();
    TextEditingController controllerName = TextEditingController();

    return const Scaffold(
        // appBar: const KenkoAppBar(
        //   title: 'New Reminder',
        // ),
        // body: BlocBuilder<ReminderBloc, ReminderState>(
        //   builder: (context, state) {
        //     if (state is RemindersLoadInProgress) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (state is RemindersLoadSuccess) {
        //       return Card(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Column(
        //             children: [
        //               _inputField('ID', controllerId),
        //               _inputField('Name', controllerName),
        //               ElevatedButton(
        //                 onPressed: () {
        //                   var reminder = Reminder(
        //                     id: controllerId.value.text,
        //                     name: controllerName.value.text,
        //                   );
        //                   context.read<ReminderBloc>().add(AddReminder(reminder));
        //                   Navigator.pop(context);
        //                 },
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Theme.of(context).primaryColor,
        //                 ),
        //                 child: const Text('Add Reminder'),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     } else {
        //       return const Center(
        //         child: Text('Something went wrong!'),
        //       );
        //     }
        //   },
        // ),
        );
  }

  Column _inputField(
    String field,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$field: ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          child: TextFormField(
            controller: controller,
          ),
        ),
      ],
    );
  }

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const NewReminderScreen(),
    );
  }
}
