import 'exercise.dart';

class Training {
  final String name; // Название тренировки
  final List<Exercise> exercises; // Список упражнений, входящих в тренировку

  // Конструктор класса Training, принимающий название тренировки и список упражнений
  Training({
    required this.name, // Название тренировки
    required this.exercises, // Список упражнений
  });

  // Фабричный конструктор для создания объекта Training из JSON
  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      name: json['name'], // Присваиваем название тренировки из JSON
      exercises: (json['exercises'] as List<dynamic>) // Преобразуем список упражнений из JSON
          .map((exercise) => Exercise.fromJson(exercise)) // Для каждого элемента создаём объект Exercise
          .toList(), // Преобразуем в список
    );
  }

  // Метод для преобразования объекта Training в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name, // Добавляем название тренировки в JSON
      'exercises': exercises.map((e) => e.toJson()).toList(), // Преобразуем каждый элемент упражнения в JSON
    };
  }
}
