class ExerciseCategory {
  final String title; // Название категории упражнений
  final Map<String, Training> trainings; // Карта тренировок, где ключ - название тренировки, а значение - объект Training

  // Конструктор класса ExerciseCategory с обязательными параметрами
  ExerciseCategory({
    required this.title, // Название категории
    required this.trainings, // Список тренировок в категории
  });

  // Фабричный конструктор для создания объекта ExerciseCategory из JSON
  factory ExerciseCategory.fromJson(Map<String, dynamic> json) {
    Map<String, Training> trainings = {}; // Создаём пустую карту для тренировок
    json.forEach((key, value) {
      if (key != 'title') { // Игнорируем ключ 'title', так как он уже обработан
        trainings[key] = Training.fromJson(value); // Преобразуем значение в объект Training и добавляем в карту
      }
    });
    return ExerciseCategory(
      title: json['title'], // Присваиваем название категории из JSON
      trainings: trainings, // Присваиваем карту тренировок
    );
  }

  // Метод для преобразования объекта ExerciseCategory в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title, // Добавляем название категории в JSON
      for (var entry in trainings.entries) // Для каждой тренировки в карте
        entry.key: entry.value.toJson(), // Преобразуем тренировку в JSON и добавляем её в итоговый результат
    };
  }
}
