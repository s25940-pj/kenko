import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';

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
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KenkoAppBar(title: 'Reminders'),
      bottomNavigationBar: const KenkoNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 247, 34, 19),
        onPressed: () {
          Navigator.pushNamed(context, '/reminders/new-reminder');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
