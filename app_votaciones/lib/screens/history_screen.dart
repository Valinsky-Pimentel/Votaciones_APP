import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/candidate.dart';
import 'dart:convert';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Candidate> candidates = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  void loadResults() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de la Votación'),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${candidates[index].name} ${candidates[index].surname}'),
            subtitle: Text('Votos: ${candidates[index].votes}'),
          );
        },
      ),
    );
  }
}

