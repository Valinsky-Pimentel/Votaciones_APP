import 'package:flutter/material.dart';
import '../models/candidate.dart';

class CandidateTile extends StatelessWidget {
  final Candidate candidate;

  const CandidateTile({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${candidate.name} ${candidate.surname}'),
      subtitle: Text('${candidate.schoolGrade}, ${candidate.party}'),
      // Puedes agregar más detalles según sea necesario
    );
  }
}
