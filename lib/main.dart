
import 'package:flutter/material.dart';
import 'package:zitate_app/features/show_quotes/quote_screen.dart';
import 'package:zitate_app/shared/database_repository.dart';
import 'package:zitate_app/shared/shared_preferences_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final DatabaseRepository repository = SharedPreferencesRepository();
  
  runApp( MainApp(repository: repository,));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.repository});

  final DatabaseRepository repository;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuoteScreen(repository: repository,),
    );
  }
}
