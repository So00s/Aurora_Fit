class Exercise {
  final String name; // Название упражнения
  final String description; // Описание упражнения
  final String time; // Длительность выполнения упражнения (например, в минутах)
  final int calories; // Количество калорий, сжигаемых при выполнении упражнения
  final bool isCompleted; // Статус выполнения упражнения (выполнено или нет)

  // Конструктор класса Exercise с обязательными параметрами и значением по умолчанию для isCompleted
  Exercise({
    required this.name, // Название упражнения
    required this.description, // Описание упражнения
    required this.time, // Время выполнения
    required this.calories, // Калории
    this.isCompleted = false, // По умолчанию статус не выполнен
  });

  // Фабричный конструктор для создания объекта Exercise из JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'], // Присваиваем название упражнения из JSON
      description: json['description'], // Присваиваем описание упражнения из JSON
      time: json['time'], // Присваиваем время выполнения упражнения из JSON
      calories: json['calories'], // Присваиваем количество калорий из JSON
      isCompleted: json['isCompleted'] ?? false, // Присваиваем статус выполнения, если его нет - по умолчанию false
    );
  }

  // Метод для преобразования объекта Exercise в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name, // Добавляем название упражнения в JSON
      'description': description, // Добавляем описание упражнения в JSON
      'time': time, // Добавляем время выполнения в JSON
      'calories': calories, // Добавляем количество калорий в JSON
      'isCompleted': isCompleted, // Добавляем статус выполнения в JSON
    };
  }
}
