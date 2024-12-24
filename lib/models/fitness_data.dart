// lib/models/fitness_data.dart

import 'training.dart';

class FitnessData {
  final Map<String, List<TrainingSlot>> schedule; // Дни недели и тренировки

  FitnessData({required this.schedule});

  factory FitnessData.fromJson(Map<String, dynamic> json) {
    Map<String, List<TrainingSlot>> schedule = {};
    json.forEach((key, value) {
      schedule[key] = (value as List).map((e) => TrainingSlot.fromJson(e)).toList();
    });
    return FitnessData(schedule: schedule);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    schedule.forEach((key, value) {
      json[key] = value.map((e) => e.toJson()).toList();
    });
    return json;
  }
}

class TrainingSlot {
  final String time;
  Training? _training; // Приватное поле для тренировки

  TrainingSlot({required this.time, Training? training}) : _training = training;

  // Геттер для тренировки
  Training? get training => _training;

  // Сеттер для тренировки
  set training(Training? value) {
    _training = value;
  }

  factory TrainingSlot.fromJson(Map<String, dynamic> json) {
    return TrainingSlot(
      time: json['time'],
      training: json['training'] != null ? Training.fromJson(json['training']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'training': training?.toJson(),
      };
}
