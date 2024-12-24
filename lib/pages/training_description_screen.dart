
//lib/pages/training_description_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import "package:aurora_fit/services/fitness_data_service.dart";
import 'package:aurora_fit/models/exercise.dart' as ex;
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:collection/collection.dart';

class TrainingDescriptionScreen extends StatefulWidget {
  final String trainingType; // Тип тренировки (например, "cardio")
  final String trainingName; // Название конкретной тренировки из файла .json (например, "first")

  const TrainingDescriptionScreen({
    Key? key,
    required this.trainingType,
    required this.trainingName,
  }) : super(key: key);

  @override
  _DescriptionOfTrainingState createState() => _DescriptionOfTrainingState();
}

class _DescriptionOfTrainingState extends State<TrainingDescriptionScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Описание тренировки'),
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

            Training? training = _getTrainingToAdd();
            if (training == null) {
              return const Center(child: Text('Тренировка не найдена'));
            }

            return _buildTrainingDetails(training);
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }

  Widget _buildTrainingDetails(Training training) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: training.exercises.length,
      itemBuilder: (context, index) {
        final ex.Exercise exercise = training.exercises[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(exercise.description),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Время: ${exercise.time}'),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.red),
                        const SizedBox(width: 4),
                        Text('${exercise.calories} калорий'),
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
  }

  Training? _getTrainingToAdd() {
    if (_fitnessData == null) return null;

    // Получаем список тренировочных слотов для выбранного дня
    var daySlots = _fitnessData!.schedule[widget.trainingType];
    if (daySlots == null) return null;

    // Ищем слот, соответствующий названию тренировки
    var slot = daySlots.firstWhereOrNull(
      (slot) => slot.training?.name == widget.trainingName,
    );

    return slot?.training;
  }
}
