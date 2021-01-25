class Task {
  String title;
  int id;
  DateTime date;
  String priority;
  int status;

  Task({
    this.title,
    this.date,
    this.priority,
    this.status,
  });

  Task.withid({
    this.id,
    this.title,
    this.date,
    this.priority,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withid(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      priority: map['priority'],
    );
  }
}
