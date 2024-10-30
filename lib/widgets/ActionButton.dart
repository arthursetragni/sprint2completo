import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // Define a cor do texto como branca
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AccountActions extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onDelete;

  const AccountActions({
    super.key,
    required this.onConfirm,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botão verde para confirmar as alterações
        ActionButton(
          text: 'Confirmar Alterações',
          color: Colors.green,
          onPressed: onConfirm,
        ),
        const SizedBox(height: 16),
        // Botão vermelho para excluir a conta
        ActionButton(
          text: 'Excluir Conta',
          color: Colors.red,
          onPressed: onDelete,
        ),
      ],
    );
  }
}
