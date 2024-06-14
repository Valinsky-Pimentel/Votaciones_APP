import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/voting.dart';
import '../models/candidate.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveVoting(Voting voting) async {
    try {
      await _firestore.collection('votings').add({
        'candidates': voting.candidates.map((candidate) => {
          'name': candidate.name,
          'surname': candidate.surname,
          'schoolGrade': candidate.schoolGrade,
          'party': candidate.party,
        }).toList(),
      });
    } catch (e) {
      print('Error al guardar la votación: $e');
    }
  }

  Future<List<Voting>> getVotings() async {
    try {
      final querySnapshot = await _firestore.collection('votings').get();
      return querySnapshot.docs.map((doc) {
        final List<Map<String, dynamic>> candidatesData =
            List<Map<String, dynamic>>.from(doc['candidates']);
        final List<Candidate> candidates = candidatesData.map((candidateData) {
          return Candidate(
            name: candidateData['name'],
            surname: candidateData['surname'],
            schoolGrade: candidateData['schoolGrade'],
            party: candidateData['party'],
          );
        }).toList();
        return Voting(candidates: candidates);
      }).toList();
    } catch (e) {
      print('Error al recuperar las votaciones: $e');
      return [];
    }
  }

  Future<void> updateVoting(String votingId, Voting updatedVoting) async {
    try {
      await _firestore.collection('votings').doc(votingId).update({
        'candidates': updatedVoting.candidates.map((candidate) => {
          'name': candidate.name,
          'surname': candidate.surname,
          'schoolGrade': candidate.schoolGrade,
          'party': candidate.party,
        }).toList(),
      });
    } catch (e) {
      print('Error al actualizar la votación: $e');
    }
  }
}
