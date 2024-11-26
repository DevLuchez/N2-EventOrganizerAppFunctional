

import '../models/event_model.dart';
import '../services/firestore_service.dart';

class EventController {
  final FirestoreService _firestoreService = FirestoreService(); // Instância para comunicação com o Firestore

  // Função para adicionar evento
  Future<void> addEvent(String title, String description, String createdAt, String scheduledDate) async {
    EventModel event = EventModel(
      title: title,
      description: description,
      createdAt: createdAt,
      scheduledDate: scheduledDate,
    );
    await _firestoreService.addEvent(event); // Chama o serviço de Firestore para adicionar
  }

  // Função para obter todos os eventos existentes no banco de dados
  Stream<List<EventModel>> getEvents() {
    return _firestoreService.getEvents(); // Retorna um stream de eventos do Firestore
  }

  // Função para atualizar evento existente
  Future<void> updateEvent(String docID, String title, String description, String createdAt, String scheduledDate) async {
    EventModel event = EventModel(
      id: docID,
      title: title,
      description: description,
      createdAt: createdAt,
      scheduledDate: scheduledDate,
    );
    await _firestoreService.updateEvent(docID, event); // Atualiza o evento no Firestore
  }

  // Função para deletar evento existente
  Future<void> deleteEvent(String docID) async {
    await _firestoreService.deleteEvent(docID); // Deleta o evento do Firestore
  }
}
