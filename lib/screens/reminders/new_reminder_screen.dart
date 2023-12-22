import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';

class NewReminderScreen extends StatelessWidget {
  const NewReminderScreen({Key? key}) : super(key: key);

  static const routeName = '/reminders/new-reminder';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: KenkoAppBar(
          title: 'Medication Name',
        ),
        body: Column(
          children: [
            InputLabel(text: 'Medication Name', isRequired: true),
            // TODO: Add proper input
            InputLabel(text: 'Interval selection', isRequired: true),
          ],
        ));
  }

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const NewReminderScreen(),
    );
  }
}
