import 'training.dart';

class TypesOfTrainings {
  final Map<String, TrainingCategory> categories; // Карта категорий тренировок, где ключ - имя категории, значение - объект TrainingCategory

  // Конструктор класса TypesOfTrainings, принимающий карту категорий тренировок
  TypesOfTrainings({required this.categories});

  // Фабричный конструктор для создания объекта TypesOfTrainings из JSON
  factory TypesOfTrainings.fromJson(Map<String, dynamic> json) {
    // Преобразуем карту категорий из JSON
    final categories = json.map((key, value) {
      return MapEntry(key, TrainingCategory.fromJson(value)); // Для каждого элемента создаём объект TrainingCategory
    });
    return TypesOfTrainings(categories: categories); // Возвращаем новый объект с категориями
  }

  // Метод для преобразования объекта TypesOfTrainings в формат JSON
  Map<String, dynamic> toJson() {
    // Преобразуем карту категорий в JSON
    return categories.map((key, value) => MapEntry(key, value.toJson())); // Преобразуем каждую категорию в JSON
  }
}

class TrainingCategory {
  final String title; // Название категории тренировок
  final Map<String, Training> trainings; // Карта тренировок, где ключ - название тренировки, значение - объект Training

  // Конструктор класса TrainingCategory, принимающий название категории и карту тренировок
  TrainingCategory({required this.title, required this.trainings});

  // Фабричный конструктор для создания объекта TrainingCategory из JSON
  factory TrainingCategory.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String; // Извлекаем название категории из JSON
    // Преобразуем список тренировок, удаляя ключ 'title', чтобы оставить только тренировки
    final trainings = (json..remove('title')).map((key, value) {
      return MapEntry(key, Training.fromJson(value)); // Преобразуем каждую тренировку в объект Training
    });
    return TrainingCategory(title: title, trainings: trainings); // Возвращаем объект категории с тренировками
  }

  // Метод для преобразования объекта TrainingCategory в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title, // Добавляем название категории в JSON
      ...trainings.map((key, value) => MapEntry(key, value.toJson())), // Преобразуем каждую тренировку в JSON и добавляем её в итоговый результат
    };
  }
}
