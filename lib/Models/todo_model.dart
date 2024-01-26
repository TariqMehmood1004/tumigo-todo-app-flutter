class Todo {
  int id;
  String title;
  String description;
  String dateTime;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isCompleted,
  });

  String getShortContent({int shortWordsLength = 5, String columnName = ''}) {
    // Split the description into words
    List<String> words = columnName.split(' ');

    // Take the first 8 words
    List<String> shortWords = words.take(shortWordsLength).toList();

    // Join the words back into a string
    return shortWords.join(' ');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      dateTime: map['dateTime'] ?? "",
      isCompleted: map['isCompleted'] == 1 ? true : false,
    );
  }
}
