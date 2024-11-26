import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';

import '../controllers/event_controller.dart';
import '../models/event_model.dart';

class EventFormPage extends StatefulWidget {
  final EventModel? event;

  const EventFormPage({super.key, this.event});

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final EventController _eventController = EventController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late String _createdAt;
  late TextEditingController _scheduledDateController;

  bool _isError = false;

  @override
  void initState() {
    super.initState();

    _scheduledDateController = TextEditingController();

    // Verifica se o evento selecionado existe ou não
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _createdAt = widget.event!.createdAt;
      _scheduledDateController.text = widget.event!.scheduledDate;
    } else {
      _createdAt = _formatDate(DateTime.now());
      _scheduledDateController.text = '';
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  // Função de validação antes de salvar
  bool _validateFields() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _scheduledDateController.text.isEmpty) {
      setState(() {
        _isError = true;  // Ativa a mensagem de erro
      });
      return false;
    }
    setState(() {
      _isError = false;  // Desativa a mensagem de erro
    });
    return true;
  }

  void _saveEvent() {
    if (!_validateFields()) {
      return;  // Não salva se algum campo não foi preenchido
    }
    String scheduledDate = _scheduledDateController.text;
    String eventTitle = _titleController.text;

    // Se widget.event for vazia, adicionar novo evento
    if (widget.event == null) {
      _eventController.addEvent(
        _titleController.text,
        _descriptionController.text,
        _createdAt,
        scheduledDate,
      );
    } else { // Se widget.event não for vazia, editar um evento existente a partir de seu id
      _eventController.updateEvent(
        widget.event!.id!,
        _titleController.text,
        _descriptionController.text,
        _createdAt,
        scheduledDate,
      );
    }
    Navigator.pop(context, {'success': true, 'title': eventTitle, 'operation': widget.event == null ? 'created' : 'updated'}); // Retorna a operação realizada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'New Event' : 'Modify Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DateTimeField(
              controller: _scheduledDateController,
              format: DateFormat("yyyy-MM-dd"),
              decoration: const InputDecoration(labelText: 'Scheduled Data'),
              onShowPicker: (context, currentValue) async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                return selectedDate;
              },
            ),
            const SizedBox(height: 40),

            Text(
              "Date of Registration: $_createdAt",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 40),

            // Se houver erros (campos não preenchidos), exibe mensagem de erro
            if (_isError)
              const Text(
                'It is mandatory to fill in all fields!',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text(widget.event == null ? 'Create' : 'Modify'), // Nomeia o botão de gravação de dados dependendo da ação executada pelo usuário (criação ou edição)
            ),
          ],
        ),
      ),
    );
  }
}
