import 'package:flutter/material.dart';
import '../models/candidate.dart';

class CandidateForm extends StatefulWidget {
  final Function(Candidate) onSubmit;

  const CandidateForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _CandidateFormState createState() => _CandidateFormState();
}

class _CandidateFormState extends State<CandidateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _schoolGradeController = TextEditingController();
  final _partyController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final candidate = Candidate(
        name: _nameController.text,
        surname: _surnameController.text,
        schoolGrade: _schoolGradeController.text,
        party: _partyController.text,
      );
      widget.onSubmit(candidate);
      _nameController.clear();
      _surnameController.clear();
      _schoolGradeController.clear();
      _partyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un apellido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _schoolGradeController,
              decoration: const InputDecoration(labelText: 'Grado Escolar'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un grado escolar';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _partyController,
              decoration: const InputDecoration(labelText: 'Partido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un partido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 138, 42, 68)), // Color de fondo del botón
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Color del texto del botón
              ),
              child: Text(
                'Agregar Candidato',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
