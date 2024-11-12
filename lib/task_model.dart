class Task {
  final String id;
  final String title;
  final String description;

  Task({required this.id, required this.title, required this.description});

  // A method to create a Task from a Firestore document
  factory Task.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return Task(
      id: id,
      title: firestoreData['title'],
      description: firestoreData['description'],
    );
  }

  // Convert Task to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
