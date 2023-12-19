import 'package:flutter/material.dart';
import 'package:kenko/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RemindersScreen.routeName:
        return RemindersScreen.route();
      case MedicationsScreen.routeName:
        return MedicationsScreen.route();
      case AccountScreen.routeName:
        return AccountScreen.route();
      case SettingsScreen.routeName:
        return SettingsScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
