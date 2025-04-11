class Task {
  String name;
  bool completed;

  Task({required this.name, required this.completed});

  //convert task object to JSON

  Map<String, dynamic> toJson() {
    return {'name': name, 'completed': completed};
  }

  //convert JSON to task object

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(name: json['name'], completed: json['completed']);
  }
}
