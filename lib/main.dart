import 'package:flutter/material.dart';
import 'core/database/app_database.dart';
import 'features/scratchpad/scratchpad_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();

  runApp(PersonalOsApp(database: database));
}

class PersonalOsApp extends StatelessWidget {
  final AppDatabase database;

  const PersonalOsApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: ScratchpadScreen(database: database),
    );
  }
}