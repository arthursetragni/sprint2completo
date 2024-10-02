import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlockButtonLogin extends StatelessWidget {
  final String label;
  final Widget icon;
  final Function()? onPressed;
  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    textStyle: const TextStyle(fontSize: 18),
    padding: const EdgeInsets.all(18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    foregroundColor: Colors.black,
  );

  BlockButtonLogin(
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
        icon: icon,
        style: buttonStyle,
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
