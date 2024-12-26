class FitnessData {
  final Map<String, List<TrainingSlot>> schedule; // Расписание тренировок по дням недели (ключ - день, значение - список тренировок)

  // Конструктор класса FitnessData, принимающий расписание тренировок
  FitnessData({required this.schedule});

  // Фабричный конструктор для создания объекта FitnessData из JSON
  factory FitnessData.fromJson(Map<String, dynamic> json) {
    return FitnessData(
      schedule: json.map((key, value) {
        return MapEntry(
          key, // Ключ (день недели)
          (value as List) // Преобразуем значение в список тренировок
              .map((e) => TrainingSlot.fromJson(e)) // Преобразуем каждый элемент списка в объект TrainingSlot
              .toList(),
        );
      }),
    );
  }

  // Метод для преобразования объекта FitnessData в формат JSON
  Map<String, dynamic> toJson() {
    return {
      for (var entry in schedule.entries)
        entry.key: entry.value.map((e) => e.toJson()).toList(), // Преобразуем список тренировок в JSON
    };
  }
}

class TrainingSlot {
  final String begintime; // Время начала тренировки
  final String category; // Категория тренировки (например, кардио, силовые и т.д.)
  bool isCompleted;
  final WorkoutSummary workout; // Сводная информация о тренировке (объект WorkoutSummary)

  // Конструктор класса TrainingSlot
  TrainingSlot({
    required this.begintime, // Время начала тренировки
    required this.category, // Категория тренировки
    required this.isCompleted,
    required this.workout, // Сводная информация о тренировке
  });

  // Фабричный конструктор для создания объекта TrainingSlot из JSON
  factory TrainingSlot.fromJson(Map<String, dynamic> json) {
    return TrainingSlot(
      begintime: json['begintime'], // Время начала тренировки
      category: json['category'], // Категория тренировки
      isCompleted: json['isCompleted'],
      workout: WorkoutSummary.fromJson(json['workout']), // Преобразуем сводную информацию о тренировке из JSON
    );
  }

  // Метод для преобразования объекта TrainingSlot в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'begintime': begintime, // Время начала тренировки
      'category': category, // Категория тренировки
      'isCompleted': isCompleted,
      'workout': workout.toJson(), // Преобразуем сводную информацию о тренировке в JSON
    };
  }
}

class WorkoutSummary {
  final String name; // Название тренировки
  final int calories; // Количество калорий, сжигаемых во время тренировки
  final String duration; // Длительность тренировки (например, в минутах)

  // Конструктор класса WorkoutSummary
  WorkoutSummary({
    required this.name, // Название тренировки
    required this.calories, // Калории
    required this.duration, // Длительность тренировки
  });

  // Фабричный конструктор для создания объекта WorkoutSummary из JSON
  factory WorkoutSummary.fromJson(Map<String, dynamic> json) {
    return WorkoutSummary(
      name: json['name'], // Название тренировки
      calories: json['calories'], // Количество калорий
      duration: json['duration'], // Длительность тренировки
    );
  }

  // Метод для преобразования объекта WorkoutSummary в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name, // Добавляем название тренировки в JSON
      'calories': calories, // Добавляем калории в JSON
      'duration': duration, // Добавляем длительность тренировки в JSON
    };
  }
}
