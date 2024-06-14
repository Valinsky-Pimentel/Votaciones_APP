import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/candidate.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Candidate> candidates = [];
  bool votingClosed = false; // Estado para controlar si la votación está cerrada

  @override
  void initState() {
    super.initState();
    loadCandidates();
  }

  void loadCandidates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? candidatesJsonList = prefs.getStringList('candidates');
    bool? closed = prefs.getBool('votingClosed') ?? false;

    if (candidatesJsonList != null) {
      List<Candidate> loadedCandidates = candidatesJsonList
          .map((jsonString) => Candidate.fromJson(jsonDecode(jsonString)))
          .toList();
      setState(() {
        candidates = loadedCandidates;
        votingClosed = closed;
      });
    }
  }

  void closeVoting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('votingClosed', true);
    setState(() {
      votingClosed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 42, 68), // Color de fondo de la AppBar
        title: Text(
          'Resultados',
          style: TextStyle(
            color: Colors.white, // Color del texto en la AppBar
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: candidates.isNotEmpty
                  ? ListView.builder(
                      itemCount: candidates.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${candidates[index].name} ${candidates[index].surname}',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Votos',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  '${candidates[index].votes}',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 138, 42, 68),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No hay candidatos para mostrar',
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    ),
            ),
            votingClosed
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: closeVoting,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 138, 42, 68)),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 12.0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cerrar Votación',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
