import 'package:flutter/material.dart';

/// Mostra um diálogo de confirmação e devolve `true` só se o usuário
/// confirmar a exclusão. Usado nas telas que têm botão de excluir
/// (ocorrência, estabelecimento, evidência).
Future<bool> confirmarExclusao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}
