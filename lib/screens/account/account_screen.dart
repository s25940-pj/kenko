import 'package:flutter/material.dart';
import 'package:kenko/widgets/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String routeName = '/account';

  @override
  State<AccountScreen> createState() => _AccountScreenState();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AccountScreen(),
    );
  }
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: KenkoAppBar(title: 'Account'),
      bottomNavigationBar: KenkoNavBar(),
    );
  }
}
