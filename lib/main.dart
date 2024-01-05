import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenko/blocs/blocs.dart';
import 'package:kenko/config/app_router.dart';
import 'package:kenko/repositories/reminder/reminder_repository.dart';
import 'package:kenko/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ReminderBloc(
                  reminderRepository: ReminderRepository(),
                )..add(LoadReminders()))
      ],
      child: MaterialApp(
        title: 'Kenko',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: RemindersScreen.routeName,
        home: const RemindersScreen(),
      ),
    );
  }
}
