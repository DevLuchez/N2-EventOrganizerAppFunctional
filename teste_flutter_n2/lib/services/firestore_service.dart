import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class FirestoreService {
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  // CREATE - Adiciona um novo evento
  Future<void> addEvent(EventModel event) {
    return events.add(event.toMap()); // Adiciona o evento no Firestore
  }

  // READ - Retorna um stream de eventos
  Stream<List<EventModel>> getEvents() {
    return events.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
        return EventModel.fromDocument(doc.data() as Map<String, dynamic>, doc.id); // Mapeia os documentos para o modelo
      }).toList(),
    );
  }

  // UPDATE - Atualiza um evento existente
  Future<void> updateEvent(String docID, EventModel event) {
    return events.doc(docID).update(event.toMap()); // Atualiza o evento no Firestore
  }

  // DELETE - Exclui um evento existente
  Future<void> deleteEvent(String docID) {
    return events.doc(docID).delete(); // Deleta o evento do Firestore
  }
}
