//lib/pages/choosing_of_training_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:aurora_fit/services/fitness_data_service.dart";
import 'package:aurora_fit/models/exercise.dart' as ex;
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/pages/training_description_screen.dart';

class ChoosingOfTrainingScreen extends StatefulWidget {
  final String trainingType; // Тип тренировки (например, "cardio")

  const ChoosingOfTrainingScreen({Key? key, required this.trainingType})
      : super(key: key);

  @override
  _TrainingListScreenState createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<ChoosingOfTrainingScreen> {
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;

  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = FitnessDataService().loadFitnessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: FutureBuilder<FitnessData>(
        future: _fitnessDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _fitnessData = snapshot.data;
            var trainings = _getTrainings();
            String trainingTypeTitle = _getTrainingTypeTitle();

            if (trainings.isEmpty) {
              return const Center(child: Text('Нет доступных тренировок'));
            }

            return Scaffold(
              appBar: _TrainingAppBar(trainingType: trainingTypeTitle),
              body: _buildTrainingList(trainings),
            );
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }

  /// Извлечение списка тренировок
  Map<String, Training> _getTrainings() {
    if (_fitnessData == null) return {};
    var category = _fitnessData!.categories[widget.trainingType];
    if (category == null) return {};
    return category.trainings; // Возвращаем мапу тренировок с ключами
  }

  /// Получение названия типа тренировки
  String _getTrainingTypeTitle() {
    if (_fitnessData == null) return 'Нет данных';
    var category = _fitnessData!.categories[widget.trainingType];
    return category?.title ?? 'Неизвестный тип';
  }

  /// Построение списка тренировок
  Widget _buildTrainingList(Map<String, Training> trainings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        String trainingKey = trainings.keys.elementAt(index); // Ключ тренировки
        Training training = trainings[trainingKey]!; // Объект тренировки
        return _buildTrainingCard(trainingKey, training); // Передаём ключ и объект тренировки
      },
    );
  }

  /// Карточка тренировки
  Widget _buildTrainingCard(String trainingKey, Training training) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.purple.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  training.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${_calculateCalories(training)} Ккал',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_calculateDuration(training)} минут',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingDescriptionScreen(
                          trainingType: widget.trainingType, // Передаём тип тренировки
                          trainingName: trainingKey, // Передаём ключ тренировки
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'подробнее',
                    style: TextStyle(
                      color: Color.fromARGB(255, 100, 4, 185),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Логика выбора тренировки
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 85, 8),
                  ),
                  child: const Text('выбрать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateDuration(Training training) {
    return training.exercises.length; // Пример: количество упражнений = минуты
  }

  int _calculateCalories(Training training) {
    return training.exercises.fold(
        0, (sum, exercise) => sum + (exercise.calories ?? 0));
  }
}

class _TrainingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String trainingType; // Название типа тренировок

  const _TrainingAppBar({
    Key? key,
    required this.trainingType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 239, 85, 8)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'AURORA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 239, 85, 8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'FIT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 4, 185),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/full.png',
                        height: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trainingType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 100, 4, 185),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120); // Размер AppBar
}
