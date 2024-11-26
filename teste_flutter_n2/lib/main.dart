import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EventOrganizerApp());
}

// StatefulWidget para permitir a alternância de tema (claro/escuro)
class EventOrganizerApp extends StatefulWidget {
  @override
  _EventOrganizerAppState createState() => _EventOrganizerAppState();
}

class _EventOrganizerAppState extends State<EventOrganizerApp> {
  // Variável para controlar o modo de tema atual (light ou dark)
  ThemeMode _themeMode = ThemeMode.light;

  // Função para alternar entre tema claro e escuro
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(), // Tema claro
      darkTheme: ThemeData.dark(), // Tema escuro

      home: HomePage(toggleTheme: _toggleTheme), // Passa a função toggleTheme para o HomePage
    );
  }
}
