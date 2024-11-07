import 'package:flutter/material.dart';

class EditableField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const EditableField({
    super.key,
    required this.title,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título do campo
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          // Campo editável do controlador
          TextFormField(
            controller: controller,
            onChanged: (value) {
              if (onChanged != null) {
                onChanged!(value);
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              isDense: true, // Reduz o tamanho do campo
            ),
          ),
        ],
      ),
    );
  }
}
