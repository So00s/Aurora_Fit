// lib/pages/schedule_screen.dart

import 'package:flutter/material.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/pages/training_selection_page.dart';
import 'package:aurora_fit/models/exercise.dart' as ex; // Псевдоним для Exercise
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/models/training.dart'; 
import 'package:aurora_fit/classes/gradient_button.dart'; 
import 'package:aurora_fit/pages/start_training_page.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;
  final FitnessDataService _fitnessDataService = FitnessDataService();

  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = _fitnessDataService.loadFitnessData();
  }

  void _addTraining(String categoryKey, String trainingKey, Training training) {
    setState(() {
      _fitnessData?.categories[categoryKey]?.trainings[trainingKey]?.exercises
          .addAll(training.exercises);
    });
    _saveData();
  }

  void _toggleExerciseCompletion(
      String categoryKey, String trainingKey, int exerciseIndex) {
    setState(() {
      ex.Exercise exercise =
          _fitnessData!.categories[categoryKey]!.trainings[trainingKey]!
              .exercises[exerciseIndex];
      exercise.isCompleted = !exercise.isCompleted;
    });
    _saveData();
  }

  Future<void> _saveData() async {
    if (_fitnessData != null) {
      await _fitnessDataService.saveFitnessData(_fitnessData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Увеличиваем высоту AppBar
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          automaticallyImplyLeading: false, // Убираем стандартный отступ для стрелки
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 0.0), // Отступ сверху
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 239, 85, 8)),
                  onPressed: () {
                    Navigator.pop(context); // Возврат на предыдущий экран
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
                      const Text(
                        'Расписание тренировок',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 4, 185),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Общий отступ для экрана
                child: Column(
                  children: _fitnessData!.categories.entries.map((categoryEntry) {
                    String categoryKey = categoryEntry.key;
                    var category = categoryEntry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...category.trainings.entries.map((trainingEntry) {
                          String trainingKey = trainingEntry.key;
                          Training training = trainingEntry.value;
                          return DaySchedule(
                            categoryKey: categoryKey,
                            trainingKey: trainingKey,
                            training: training,
                            color: _getDayColor(categoryKey, trainingKey),
                            onAdd: (newTraining) {
                              _addTraining(categoryKey, trainingKey, newTraining);
                            },
                            onToggleComplete: (exerciseIndex) {
                              _toggleExerciseCompletion(
                                  categoryKey, trainingKey, exerciseIndex);
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }

  Color _getDayColor(String categoryKey, String trainingKey) {
    // Определение цвета на основе категории и тренировки
    if (categoryKey == 'cardio') {
      if (trainingKey == 'first') {
        return const Color.fromARGB(255, 255, 214, 199);
      } else if (trainingKey == 'second') {
        return const Color.fromARGB(155, 239, 85, 8);
      }
      // Добавьте другие условия по необходимости
    } else if (categoryKey == 'power') {
      if (trainingKey == 'first') {
        return const Color.fromARGB(112, 236, 198, 225);
      }
      // Добавьте другие условия по необходимости
    }
    return Colors.grey;
  }
}

class DaySchedule extends StatelessWidget {
  final String categoryKey;
  final String trainingKey;
  final Training training;
  final Color color;
  final Function(Training) onAdd;
  final Function(int) onToggleComplete;

  const DaySchedule({
    Key? key,
    required this.categoryKey,
    required this.trainingKey,
    required this.training,
    required this.color,
    required this.onAdd,
    required this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          // Заголовок тренировки и галочка выполнения
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                training.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Галочка для выполнения тренировки
              Checkbox(
                value: _isTrainingCompleted(),
                onChanged: (value) {
                  // Логика для отметки всей тренировки как выполненной
                  // Может быть реализована через callback
                },
              ),
            ],
          ),
          // Список упражнений
          Column(
            children: training.exercises.asMap().entries.map((entry) {
              int index = entry.key;
              ex.Exercise exercise = entry.value; // Используем алиас
              return ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  exercise.time,
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Text(exercise.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${exercise.calories} ккал'),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: exercise.isCompleted,
                      onChanged: (value) {
                        onToggleComplete(index);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          // Кнопка "Добавить"
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                _showTimePicker(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить'),
            ),
          ),
          // Кнопка "Начать тренировку"
          Align(
            alignment: Alignment.centerRight,
            child: GradientButton(
              text: 'Начать тренировку',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartTrainingPage(training: training),
                  ),
                ).then((value) {
                  if (value != null && value == true) {
                    // Обновить состояние тренировки как выполненной
                    // Реализуйте соответствующую логику
                  }
                });
              },
            ),
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }

  bool _isTrainingCompleted() {
    return training.exercises.every((exercise) => exercise.isCompleted);
  }

  void _showTimePicker(BuildContext context) {
    // Оставляем метод без изменений или реализуем добавление новой тренировки
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Для полной высоты
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.2, // 1/5 экрана
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Выберите время',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(24, (hour) {
                String formattedHour = hour.toString().padLeft(2, '0');
                return ListTile(
                  title: Text(
                    '$formattedHour:00',
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToTrainingSelection(context, '$formattedHour:00');
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _navigateToTrainingSelection(BuildContext context, String time) async {
    final selectedTraining = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingSelectionPage(
          selectedTime: time,
          categoryKey: categoryKey,
          sessionKey: trainingKey,
        ),
      ),
    );

    if (selectedTraining != null && selectedTraining is Training) {
      onAdd(selectedTraining);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Тренировка "${selectedTraining.name}" добавлена в $time')),
      );
    }
  }
}