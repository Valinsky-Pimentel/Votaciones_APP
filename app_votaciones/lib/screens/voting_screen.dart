import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/candidate.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({Key? key}) : super(key: key);

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  List<Candidate> candidates = [];
  bool votingClosed = false;

  @override
  void initState() {
    super.initState();
    loadCandidates();
    checkVotingStatus();
  }

  void loadCandidates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? candidatesJsonList = prefs.getStringList('candidates');
    if (candidatesJsonList != null) {
      List<Candidate> loadedCandidates = candidatesJsonList
          .map((jsonString) => Candidate.fromJson(jsonDecode(jsonString)))
          .toList();
      setState(() {
        candidates = loadedCandidates;
      });
    }
  }

  void checkVotingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? storedVotingClosed = prefs.getBool('votingClosed');
    if (storedVotingClosed != null) {
      setState(() {
        votingClosed = storedVotingClosed;
      });
    }
  }

  void voteForCandidate(int index) async {
    if (!votingClosed) {
      setState(() {
        candidates[index].votes += 1;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> candidatesJsonList =
          candidates.map((candidate) => jsonEncode(candidate.toJson())).toList();
      await prefs.setStringList('candidates', candidatesJsonList);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Voto Registrado'),
          content: Text('Has votado por ${candidates[index].name} ${candidates[index].surname}.'),
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
  }

  void closeVoting() async {
    setState(() {
      votingClosed = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('votingClosed', true);
    Navigator.pop(context); // Regresar a la pantalla anterior al cerrar la votación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 42, 68), // Color de fondo de la AppBar
        title: Text(
          'Es momento de VOTAR',
          style: TextStyle(
            color: Colors.white, // Color del texto en la AppBar
          ),
        ),
      ),
      body: votingClosed ? _buildClosedVotingScreen() : _buildOpenVotingScreen(),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    if (!votingClosed) {
      closeVoting();
    }
  },
  tooltip: 'Cerrar Votación',
  backgroundColor: Color.fromARGB(255, 138, 42, 68), // Color de fondo del botón
  child: const Icon(
    Icons.how_to_vote,
    color: Colors.white, // Color del icono
  ),
),

    );
  }

  Widget _buildOpenVotingScreen() {
    return ListView.builder(
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text(
              '${candidates[index].name} ${candidates[index].surname}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Partido: ${candidates[index].party}',
              style: TextStyle(fontSize: 14.0),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                voteForCandidate(index);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 138, 42, 68)),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: const Text(
                'Votar',
                style: TextStyle(fontSize: 14.0, color: Colors.white), // Color del texto blanco
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClosedVotingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Votación Cerrada',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 138, 42, 68)),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 138, 42, 68)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              ),
            ),
            child: const Text(
              'Regresar',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
