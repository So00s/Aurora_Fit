// lib/models/fitness_data.dart

import 'training.dart';

class TypesOfTrainings {
  final Map<String, ExerciseCategory> categories;

  TypesOfTrainings({required this.categories});

  factory TypesOfTrainings.fromJson(Map<String, dynamic> json) {
    Map<String, ExerciseCategory> categories = {};
    json.forEach((key, value) {
      categories[key] = ExerciseCategory.fromJson(value);
    });
    return TypesOfTrainings(categories: categories);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    categories.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }
}

class ExerciseCategory {
  final String title;
  final Map<String, Training> trainings;

  ExerciseCategory({required this.title, required this.trainings});

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) {
    Map<String, Training> trainings = {};
    json.forEach((key, value) {
      if (key != 'title') {
        trainings[key] = Training.fromJson(value);
      }
    });
    return ExerciseCategory(title: json['title'], trainings: trainings);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {'title': title};
    trainings.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }
}
