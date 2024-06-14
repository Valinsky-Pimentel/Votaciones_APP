import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/create_voting_screen.dart';
import 'screens/voting_screen.dart';
import 'screens/results_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/createVoting': (context) => const CreateVotingScreen(),
        '/voting': (context) => const VotingScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}
