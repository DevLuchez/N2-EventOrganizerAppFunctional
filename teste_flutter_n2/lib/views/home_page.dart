import 'package:flutter/material.dart';
import '../components/delete_confirmation_popup.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'event_form_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;  // Função para alternar o tema (claro/escuro)

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EventController _eventController = EventController();

  // Função para abrir o formulário de evento, podendo ser para adicionar ou editar
  void _openEventForm([EventModel? event]) async {

    final result = await Navigator.push( // Navega para a página de formulário de evento e aguarda o resultado
      context,
      MaterialPageRoute(
        builder: (_) => EventFormPage(
          event: event,  // Passa o evento atual, caso seja edição
        ),
      ),
    );

    // Verifica se a operação foi bem-sucedida
    if (result != null && result['success'] == true) {
      String eventTitle = result['title'];
      String operation = result['operation'];

      // Define a mensagem de sucesso com base na ação executada pelo usuário (criação ou edição)
      String message = '';
      if (operation == 'created') {
        message = 'Event "$eventTitle" created successfully!';
      } else if (operation == 'updated') {
        message = 'Event "$eventTitle" changed successfully!';
      }

      // Exibe a mensagem de sucesso após 1 segundo de espera
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      });
    }
  }

  // Função para excluir um evento, com confirmação do usuário
  void _deleteEventWithConfirmation(EventModel event) {
    // Exibe o popup de confirmação
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationPopup(
          eventTitle: event.title,
          onConfirm: () async {
            Navigator.of(context).pop(); // Fecha o dialog
            await _eventController.deleteEvent(event.id!); // Exclui o evento

            // Exibe a mensagem de sucesso de exclusão
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Event "${event.title}" deleted successfully!')),
            );
          },
          onCancel: () {
            Navigator.of(context).pop(); // Fecha o dialog sem excluir
          },
        );
      },
    );
  }

  // Função build para a construção da interface do usuário
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Organizer App"),
        actions: [
          // Botão na AppBar para alternar tema, usando o ícone adequado com base no tema atual
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Color(0xFF8C52FF),
            ),
            onPressed: widget.toggleTheme, // Chama a função de alternância de tema
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEventForm(),  // Abre o formulário de criação de evento
        child: const Icon(
          Icons.add,
          color: Color(0xFFF0F0F0),
        ),
        backgroundColor: const Color(0xFF8C52FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      // StreamBuilder para exibir a lista de eventos a partir de um stream de dados
      body: StreamBuilder<List<EventModel>>(
        stream: _eventController.getEvents(),  // Obtém os eventos do controlador
        builder: (context, snapshot) {
          print(snapshot.data);

          // Se os dados forem recebidos com sucesso
          if (snapshot.hasData) {
            var eventsList = snapshot.data!;  // Lista de eventos
            return ListView.builder(
              itemCount: eventsList.length,
              itemBuilder: (context, index) {
                var event = eventsList[index];  // Evento atual na lista
                return ListTile(
                  title: Text(event.title),  // Título do evento
                  subtitle: Text(event.description),  // Descrição do evento
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão para editar o evento
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _openEventForm(event),  // Passa o evento para edição
                      ),
                      // Botão para excluir o evento
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Color(0xFFED9A9A),
                        onPressed: () => _deleteEventWithConfirmation(event),  // Chama a função de exclusão com confirmação
                      ),
                    ],
                  ),
                );
              },
            );
          }

          // Caso ocorra um erro na recuperação dos dados
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text("Error loading events, please contact laura.luchez@catolicasc.edu.br"));
          }
          // Caso não haja eventos disponíveis
          else {
            return const Center(child: Text("No events found."));
          }
        },
      ),
    );
  }
}
