// lib/services/found_workout.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/training.dart';

class WorkoutService {
  // Загрузка данных из all_workouts.json
  Future<Map<String, dynamic>> loadAllWorkouts() async {
    final String jsonString = await rootBundle.loadString('lib/json/all_workouts.json');
    return jsonDecode(jsonString);
  }

  // Поиск тренировки по категории и имени
  Future<Training?> findTraining(String category, String name) async {
    final allWorkouts = await loadAllWorkouts();

    if (allWorkouts.containsKey(category)) {
      final categoryData = allWorkouts[category];

      for (var entry in (categoryData as Map<String, dynamic>).entries) {
        if (entry.key == 'title') continue; // Пропустить заголовок категории

        final trainingData = entry.value as Map<String, dynamic>;
        if (trainingData['name'] == name) {
          return Training.fromJson(trainingData);
        }
      }
    }
    return null; // Тренировка не найдена
  }

    // Получение названия категории
  Future<String> getCategoryTitle(String category) async {
    final allWorkouts = await loadAllWorkouts();
    if (allWorkouts.containsKey(category)) {
      final categoryData = allWorkouts[category];
      return categoryData['title'] ?? 'Зарядка';
    }
    return 'Зарядка';
  }
}
