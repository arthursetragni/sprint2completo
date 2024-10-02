import 'package:flutter/material.dart';

class BlockButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onPressed;
  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    textStyle: const TextStyle(fontSize: 18),
    padding: const EdgeInsets.all(18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    foregroundColor: Colors.white,
  );
  BlockButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ElevatedButton.icon(
        style: buttonStyle,
        label: Text(label),
        onPressed: onPressed,
        // paintBorder:
      ),
    );
  }
}
