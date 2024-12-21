import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:aurora_fit/services/fitness_data_service.dart";


class DescriptionOfTraining extends StatefulWidget {
  final String trainingType; // Тип тренировки (например, "cardio")
  final String trainingName; // Название конкретной тренировки (например, "Первая тренировка")

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

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final jsonString = await rootBundle.loadString('json/types_of_trainings.json');
    final data = json.decode(jsonString);
    final training = data[widget.trainingType]?[widget.trainingName];

    if (training != null) {
      setState(() {
        exercises = training['exercises'];
      });
    }
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
              padding: const EdgeInsets.only(top: 0.0),
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
                        const Text(
                          'Описание тренировки',
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: exercises.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _ExerciseCard(
                        title: exercise['name'],
                        description: exercise['description'],
                        duration: exercise['time'] ?? 'Не указано',
                        calories: '${exercise['calories'] ?? ''} Ккал',
                        backgroundColor: index.isEven
                            ? Colors.orange.shade200
                            : Colors.pink.shade100,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
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
