import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BotaoRecebeIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor; // Adiciona um parâmetro para a cor

  const BotaoRecebeIcon(this.icon, {Key? key, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 255, 238, 0),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(
        icon,
        size: 30, // tamanho do ícone
        color: iconColor, // Aplicando a cor dinâmica
      ),
    );
  }
}

