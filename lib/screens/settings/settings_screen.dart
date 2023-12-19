import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SettingsScreen(),
    );
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KenkoAppBar(title: 'Settings'),
      bottomNavigationBar: const KenkoNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 247, 34, 19),
        onPressed: () => setState(() {}),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
