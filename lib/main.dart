import 'package:flutter/material.dart';
import 'package:kenko/config/app_router.dart';
import 'package:kenko/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kenko',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: RemindersScreen.routeName,
      home: const RemindersScreen(),
    );
  }
}
