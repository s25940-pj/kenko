import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  static const String routeName = '/medications';

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const MedicationsScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KenkoAppBar(title: 'Medications'),
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
