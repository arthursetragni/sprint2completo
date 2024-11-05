import 'package:flutter/material.dart';

class BotaoRecebeIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize; // Novo parâmetro para o tamanho do ícone
  final VoidCallback? onPressed;

  const BotaoRecebeIcon(this.icon, {super.key, required this.iconColor, this.iconSize = 24.0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: iconColor,
        size: iconSize, 
      ),
      onPressed: onPressed,
    );
  }
}

