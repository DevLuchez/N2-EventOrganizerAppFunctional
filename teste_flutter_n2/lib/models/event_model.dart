class EventModel {
  String? id;
  String title;
  String description;
  String createdAt;
  String scheduledDate;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.scheduledDate,
  });

  // Método para converter o modelo em mapa (para gravar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'scheduledDate': scheduledDate,
    };
  }

  // Método para criar o modelo a partir dos dados do Firestore
  factory EventModel.fromDocument(Map<String, dynamic> docData, String docID) {
    return EventModel(
      id: docID,
      title: docData['title'],
      description: docData['description'],
      createdAt: docData['createdAt'],
      scheduledDate: docData['scheduledDate'],
    );
  }
}
