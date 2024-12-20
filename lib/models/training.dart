// lib/models/training.dart

import 'exercise.dart';

class Training {
  final String name;
  final List<Exercise> exercises;

  Training({
    required this.name,
    required this.exercises,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List<dynamic>;
    List<Exercise> exercisesList =
        exercisesFromJson.map((e) => Exercise.fromJson(e)).toList();

    return Training(
      name: json['name'],
      exercises: exercisesList,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };
}
