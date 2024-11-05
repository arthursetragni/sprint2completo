import 'package:flutter/material.dart';

class InputLogin extends StatelessWidget {
  final String title;
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const InputLogin({
    super.key,
    required this.title,
    required this.label,
    required this.isPassword,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label, // Label do campo
            ),
          ),
        ],
      ),
    );
  }
}
