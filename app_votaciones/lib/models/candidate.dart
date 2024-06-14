class Candidate {
  final String name;
  final String surname;
  final String schoolGrade;
  final String party;
  int votes;

  Candidate({
    required this.name,
    required this.surname,
    required this.schoolGrade,
    required this.party,
    this.votes = 0, // Inicializa los votos en 0
  });

  // Método estático para convertir un mapa (JSON) en una instancia de Candidate
  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      name: json['name'],
      surname: json['surname'],
      schoolGrade: json['schoolGrade'],
      party: json['party'],
      votes: json['votes'] ?? 0, // Maneja el caso en que 'votes' pueda no estar presente
    );
  }

  // Método para convertir una instancia de Candidate en un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'schoolGrade': schoolGrade,
      'party': party,
      'votes': votes,
    };
  }
}
