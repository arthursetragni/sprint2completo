import 'package:flutter/material.dart';

class EditableGenderField extends StatefulWidget {
  final String title;
  final String
      initialGender; // Valor inicial do gênero, como 'Masculino' ou 'Feminino'
  final ValueChanged<String> onGenderChanged;

  const EditableGenderField({
    super.key,
    required this.title,
    required this.initialGender,
    required this.onGenderChanged,
  });

  @override
  _EditableGenderFieldState createState() => _EditableGenderFieldState();
}

class _EditableGenderFieldState extends State<EditableGenderField> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
  }

  void _onGenderSelected(String? gender) {
    if (gender != null) {
      setState(() {
        _selectedGender = gender;
      });
      widget.onGenderChanged(gender); // Salva a escolha de gênero
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título do campo
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          // Botões de seleção de gênero
          RadioListTile<String>(
            title: const Text("Masculino"),
            value: "Masculino",
            groupValue: _selectedGender,
            onChanged: _onGenderSelected,
          ),
          RadioListTile<String>(
            title: const Text("Feminino"),
            value: "Feminino",
            groupValue: _selectedGender,
            onChanged: _onGenderSelected,
          ),
          RadioListTile<String>(
            title: const Text("Outro"),
            value: "Outro",
            groupValue: _selectedGender,
            onChanged: _onGenderSelected,
          ),
        ],
      ),
    );
  }
}
