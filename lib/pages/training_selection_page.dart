import 'package:flutter/material.dart';
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/models/exercise.dart' as ex; // Псевдоним для Exercise
import 'package:collection/collection.dart';

class TrainingSelectionPage extends StatefulWidget {
  final String selectedTime; // Время слота
  final String categoryKey; // День недели

  const TrainingSelectionPage({
    Key? key,
    required this.selectedTime,
    required this.categoryKey,
  }) : super(key: key);

  @override
  _TrainingSelectionPageState createState() => _TrainingSelectionPageState();
}

class _TrainingSelectionPageState extends State<TrainingSelectionPage> {
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
      appBar: AppBar(
        title: Text('Выберите тренировку в ${widget.selectedTime}'),
        backgroundColor: const Color.fromARGB(255, 239, 85, 8),
      ),
      body: FutureBuilder<FitnessData>(
        future: _fitnessDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _fitnessData = snapshot.data;

            // Получаем тренировку для выбранного времени
            Training? trainingToAdd = _getTrainingToAdd();
            if (trainingToAdd == null) {
              return const Center(child: Text('Нет доступных тренировок'));
            }

            // Отображаем упражнения в виде сетки
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Количество колонок
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 3 / 2, // Соотношение сторон
              ),
              itemCount: trainingToAdd.exercises.length,
              itemBuilder: (context, index) {
                final ex.Exercise exercise = trainingToAdd.exercises[index];
                return GestureDetector(
                  onTap: () {
                    _selectExercise(exercise);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.deepPurpleAccent),
                    ),
                    child: Center(
                      child: Text(
                        exercise.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }

  // Метод для получения тренировки из расписания
  Training?   _getTrainingToAdd() {
    if (_fitnessData == null) return null;

    var daySlots = _fitnessData!.schedule[widget.categoryKey];
    if (daySlots == null) return null;

    var slot = daySlots.firstWhereOrNull(
      (slot) => slot.time == widget.selectedTime,
    );

    return slot?.training;
  }

  void _selectExercise(ex.Exercise exercise) {
    // Создаём объект Training с выбранным упражнением
    Training training = Training(
      name: exercise.name,
      exercises: [exercise],
    );
    Navigator.pop(context, training);
  }
}
