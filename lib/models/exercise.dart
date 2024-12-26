class Exercise {
  final String name; // Название упражнения
  final String description; // Описание упражнения
  final String time; // Длительность выполнения упражнения (например, в минутах)
  final int calories; // Количество калорий, сжигаемых при выполнении упражнения

  // Конструктор класса Exercise с обязательными параметрами и значением по умолчанию для isCompleted
  Exercise({
    required this.name, // Название упражнения
    required this.description, // Описание упражнения
    required this.time, // Время выполнения
    required this.calories, // Калории
  });

  // Фабричный конструктор для создания объекта Exercise из JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'], // Присваиваем название упражнения из JSON
      description: json['description'], // Присваиваем описание упражнения из JSON
      time: json['time'], // Присваиваем время выполнения упражнения из JSON
      calories: json['calories'], // Присваиваем количество калорий из JSON
    );
  }

  // Метод для преобразования объекта Exercise в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name, // Добавляем название упражнения в JSON
      'description': description, // Добавляем описание упражнения в JSON
      'time': time, // Добавляем время выполнения в JSON
      'calories': calories, // Добавляем количество калорий в JSON
    };
  }
}
