//lib/pages/choosing_of_training_screen.dart

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:aurora_fit/services/fitness_data_service.dart";
import 'package:aurora_fit/models/exercise.dart' as ex;
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/models/types_of_trainings.dart';
import 'package:aurora_fit/pages/training_description_screen.dart';
import 'package:aurora_fit/services/types_of_trainings_service.dart';
import 'package:aurora_fit/pages/schedule_screen.dart';

class ChoosingOfTrainingScreen extends StatefulWidget {
  final String trainingType; // Тип тренировки (например, "cardio")
  final String dayOfWeek;

  const ChoosingOfTrainingScreen({
    Key? key, 
    required this.trainingType,
    required this.dayOfWeek,
    }) : super(key: key);

  @override
  _TrainingListScreenState createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<ChoosingOfTrainingScreen> {
  late Future<TypesOfTrainings> _trainingDataFuture;
  TypesOfTrainings? _trainingData;
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;

  @override
  void initState() {
    super.initState();
    _trainingDataFuture = TypesOfTrainingsService().loadTrainings();
    _fitnessDataFuture = FitnessDataService().loadFitnessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: FutureBuilder<TypesOfTrainings>(
        future: _trainingDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _trainingData = snapshot.data;
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
    if (_trainingData == null) return {};
    var category = _trainingData!.categories[widget.trainingType];
    if (category == null) return {};
    return category.trainings; // Возвращаем мапу тренировок с ключами
  }

  /// Получение названия типа тренировки
  String _getTrainingTypeTitle() {
    if (_trainingData == null) return 'Нет данных';
    var category = _trainingData!.categories[widget.trainingType];
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
              _calculateDuration(training),
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
                        builder: (context) => DescriptionOfTraining(
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
                    _showTimePickerDialog(widget.trainingType, training);
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

  String _calculateDuration(Training training) {
  final totalSeconds = training.exercises.fold<int>(0, (totalDuration, exercise) {
    // Парсим время упражнения в минуты и секунды
    final parts = exercise.time.split(':');
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    // Считаем общее время в секундах
    return totalDuration + (minutes * 60 + seconds);
  });

  // Преобразуем общее время обратно в формат MM:SS
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

  void _showTimePickerDialog(String trainingType, Training training) {
    int selectedHour = 8; // Время по умолчанию (час)
    int selectedMinute = 0; // Время по умолчанию (минута)

    final List<int> availableHours = List.generate(24, (index) => index); // Список доступных часов (0-23)
    final List<int> availableMinutes = List.generate(60, (index) => index); // Список доступных минут (0-59)

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите время'),
          content: SizedBox(
            height: 200,
            child: Row(
              children: [
                // Выбор часа
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedHour,
                    ),
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      selectedHour = availableHours[index];
                    },
                    children: availableHours.map((hour) => Text(hour.toString().padLeft(2, '0'))).toList(),
                  ),
                ),
                // Выбор минуты
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedMinute,
                    ),
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      selectedMinute = availableMinutes[index];
                    },
                    children: availableMinutes.map((minute) => Text(minute.toString().padLeft(2, '0'))).toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрытие диалога
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                // Формируем строку времени, проверяя корректность значений
                String selectedTime = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                
                // Убедимся, что значения времени корректны
                if (selectedHour < 0 || selectedHour > 23 || selectedMinute < 0 || selectedMinute > 59) {
                  print("Ошибка: некорректное время");
                  // Navigator.of(context).pop(); // Закрываем диалог
                  return;
                }

                // Добавляем тренировку в расписание
                await _addTrainingToSchedule(selectedTime, trainingType, training);
                // Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }


  int _calculateCalories(Training training) {
    return training.exercises.fold(
        0, (sum, exercise) => sum + (exercise.calories ?? 0));
  }

  Future<void> _addTrainingToSchedule(String begintime, String category, Training training) async {
    try {
      // Загрузка текущих данных
      final fitnessData = await FitnessDataService().loadFitnessData();

      // Создаем объект WorkoutSummary
      final workout = WorkoutSummary(
        name: training.name,
        calories: _calculateCalories(training),
        duration: _calculateDuration(training),
      );

      // Создаем новый слот тренировки
      final newSlot = TrainingSlot(
        begintime: begintime,
        category: category,
        isCompleted: false,
        workout: workout,
      );

      // Добавляем тренировку в расписание
      fitnessData.schedule[widget.dayOfWeek]?.add(newSlot);

      // Сохраняем обновленные данные
      await FitnessDataService().saveFitnessData(fitnessData);

      //Переход на главный экран и обновление
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ScheduleScreen()),
        (route) => false,
      );
      
      // Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => const ScheduleScreen()),
      //             );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Тренировка успешно добавлена!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    }
  }



  // void _showTimePickerDialog(String trainingType, Training training) {
  //   String selectedTime = "08:00"; // Время по умолчанию
  //   final List<String> availableTimes = [
  //     "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
  //     "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00"
  //   ]; // Список доступного времени
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Выберите время'),
  //         content: SizedBox(
  //           height: 200,
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: CupertinoPicker(
  //                   scrollController: FixedExtentScrollController(
  //                     initialItem: availableTimes.indexOf(selectedTime),
  //                   ),
  //                   itemExtent: 32.0,
  //                   onSelectedItemChanged: (int index) {
  //                     selectedTime = availableTimes[index];
  //                   },
  //                   children: availableTimes.map((time) => Text(time)).toList(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Отмена'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               // Добавляем тренировку в расписание
  //               await _addTrainingToSchedule(selectedTime, trainingType, training);
  //               // Navigator.of(context).pop(true); // Закрываем диалог
  //             },
  //             child: const Text('Сохранить'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
