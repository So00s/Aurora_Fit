// lib/models/exercise.dart

class Exercise {
  final String name;
  final String description;
  final String time;
  final int calories;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.description,
    required this.time,
    required this.calories,
    this.isCompleted = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      time: json['time'],
      calories: json['calories'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'time': time,
        'calories': calories,
        'isCompleted': isCompleted,
      };
}
