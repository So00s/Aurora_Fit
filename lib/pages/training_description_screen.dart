import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:aurora_fit/services/fitness_data_service.dart";
import 'package:aurora_fit/models/exercise.dart' as ex;
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';


class DescriptionOfTraining extends StatefulWidget {
  final String trainingType; // Тип тренировки (например, "cardio")
  final String trainingName; // Название конкретной тренировки из файла .json (например, "first")

  const DescriptionOfTraining({
    Key? key,
    required this.trainingType,
    required this.trainingName,
  }) : super(key: key);

  @override
  _DescriptionOfTrainingState createState() => _DescriptionOfTrainingState();
}

class _DescriptionOfTrainingState extends State<DescriptionOfTraining> {
  List<dynamic> exercises = [];
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;

  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = FitnessDataService().loadFitnessData();
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 248, 248, 248),
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: 
                  Row(
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
                            const Text(
                              'Описание тренировки:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 100, 4, 185),
                              ),
                            ),
                            FutureBuilder<FitnessData>(
                              future: _fitnessDataFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  // Получаем тренировку из данных
                                  var training = _getTrainingToAdd();
                                  return Text(
                                    training?.name ?? "Неизвестная тренировка",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 100, 4, 185),
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return const Center(child: Text('Нет данных'));
                                }
                              },
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
              Training? trainingToAdd = _getTrainingToAdd();
              if (trainingToAdd == null) {
                return const Center(child: Text('Нет доступных тренировок'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: trainingToAdd.exercises.length,
                itemBuilder: (context, index) {
                  final ex.Exercise exercise = trainingToAdd.exercises[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0), // Отступы между карточками
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Заголовок упражнения
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(120, 239, 85, 8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              exercise.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Описание упражнения
                          Text(
                            exercise.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Время выполнения и калории
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Время выполнения: ${exercise.time}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.local_fire_department,
                                      color: Colors.redAccent, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${exercise.calories} Кал',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
      ),
    );
  }
  Training? _getTrainingToAdd() {
    // Получаем тренировку из выбранной категории и сессии
    if (_fitnessData == null) return null;
    var category = _fitnessData!.categories[widget.trainingType];
    if (category == null) return null;
    var training = category.trainings[widget.trainingName];
    return training;
  }
}

class _ExerciseCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String calories;
  final Color backgroundColor;

  const _ExerciseCard({
    Key? key,
    required this.title,
    required this.description,
    required this.duration,
    required this.calories,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Время выполнения: $duration',
                  style: const TextStyle(fontSize: 14),
                ),
                if (calories.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        calories,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


