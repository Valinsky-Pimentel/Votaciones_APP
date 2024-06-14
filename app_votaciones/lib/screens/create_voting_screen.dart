import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Importa dart:convert para utilizar jsonEncode y jsonDecode
import '../models/candidate.dart';
import '../widgets/candidate_form.dart';
import 'voting_screen.dart';

class CreateVotingScreen extends StatefulWidget {
  const CreateVotingScreen({super.key});

  @override
  _CreateVotingScreenState createState() => _CreateVotingScreenState();
}

class _CreateVotingScreenState extends State<CreateVotingScreen> {
  List<Candidate> candidates = [];
  bool canStartVoting = false;

  void addCandidate(Candidate candidate) {
    setState(() {
      candidates.add(candidate);
      if (candidates.length >= 2) {
        canStartVoting = true;
      }
    });
  }

  void startVoting() async {
    if (canStartVoting) {
      // Guardar la lista de candidatos en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> candidatesJsonList = candidates.map((candidate) => candidate.toJson()).toList().map((json) => jsonEncode(json)).toList();
      await prefs.setStringList('candidates', candidatesJsonList);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VotingScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Debes agregar al menos dos candidatos para iniciar la votación.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 42, 68), // Color de fondo de la AppBar
        title: Text(
          'Crear Nueva Votación',
          style: TextStyle(
            color: Colors.white, // Color del texto en la AppBar
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: candidates.isNotEmpty
                ? ListView.builder(
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            '${candidates[index].name} ${candidates[index].surname}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          leading: CircleAvatar(
                            child: Text(candidates[index].name[0]),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No hay candidatos agregados',
                      style: TextStyle(fontSize: 18.0, color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CandidateForm(onSubmit: addCandidate),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startVoting,
        child: Icon(
          Icons.check,
          color: Colors.white, // Color del icono de la palomita
        ),
        backgroundColor: Color.fromARGB(255, 138, 42, 68), // Color de fondo del botón flotante
      ),
    );
  }
}