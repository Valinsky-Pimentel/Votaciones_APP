import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_voting_screen.dart';
import 'voting_screen.dart';
import 'results_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Votaciones',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 138, 42, 68),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMenuItem(
              context,
              'Crear una nueva votación',
              Icons.add_circle_outline,
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateVotingScreen()));
              },
            ),
            const SizedBox(height: 12.0),
            _buildMenuItem(
              context,
              'Continuar votación',
              Icons.how_to_vote,
              () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool? votingClosed = prefs.getBool('votingClosed') ?? false;

                if (!votingClosed) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VotingScreen()));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Votación Cerrada'),
                      content: const Text('La votación ha sido cerrada.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12.0),
            _buildMenuItem(
              context,
              'Ver resultados',
              Icons.bar_chart,
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color.fromARGB(255, 138, 42, 68),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
