import 'package:flutter/material.dart';

class DeleteConfirmationPopup extends StatelessWidget {
  final VoidCallback onConfirm; // Ação para confirmar a exclusão
  final VoidCallback onCancel; // Ação para cancelar a exclusão
  final String eventTitle; // Título do evento a ser exibido no popup

  const DeleteConfirmationPopup({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
    required this.eventTitle, // Recebe o título do evento
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar exclusão'),
      content: Text('Você tem certeza que deseja excluir o evento "$eventTitle"?'), // Utiliza título do evento obtido anteriormente para confirmar a exclusão de um evento específico
      actions: <Widget>[
        TextButton(
          onPressed: onCancel, // Executa a ação de cancelamento
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: onConfirm, // Executa a ação de confirmação
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
