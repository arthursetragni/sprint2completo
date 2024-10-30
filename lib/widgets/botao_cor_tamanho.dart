import 'package:flutter/material.dart';

class BotaoCorTamanho extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const BotaoCorTamanho({super.key, 
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 22)
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
