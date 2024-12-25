//lib/pages/choosing_type_of_training.dart

import 'dart:convert';
import 'package:aurora_fit/services/types_of_training_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:aurora_fit/services/fitness_data_service.dart";
import 'package:aurora_fit/models/exercise.dart' as ex;
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/pages/choosing_of_training_screen.dart';
import 'package:aurora_fit/models/types_of_trainings.dart';




class ChoosingTypeOfTrainingScreen extends StatefulWidget {
  const ChoosingTypeOfTrainingScreen({Key? key}) : super(key: key);

  @override
  _TrainingTypeSelectionScreenState createState() => _TrainingTypeSelectionScreenState();
}

class _TrainingTypeSelectionScreenState extends State<ChoosingTypeOfTrainingScreen> {
  late Future<TypesOfTrainings> _fitnessDataFuture;
  TypesOfTrainings? _fitnessData;

  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = TypesOfDataService().loadFitnessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        elevation: 0,
        title: const Text(
          'AURORA FIT',
          style: TextStyle(
            color: Color.fromARGB(255, 239, 85, 8),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 239, 85, 8)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<TypesOfTrainings>(
        future: _fitnessDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _fitnessData = snapshot.data;
            if (_fitnessData == null || _fitnessData!.categories.isEmpty) {
              return const Center(child: Text('Нет доступных типов тренировок'));
            }
            return _buildTrainingTypeGrid();
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }

  Widget _buildTrainingTypeGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Типы тренировок',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 100, 4, 185),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _fitnessData!.categories.length,
              itemBuilder: (context, index) {
                String key = _fitnessData!.categories.keys.elementAt(index);
                String title = _fitnessData!.categories[key]?.title ?? 'Неизвестно';
                IconData icon = _getIconForType(key);
                return _buildTrainingTypeCard(context, title, icon, key);
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String trainingType) {
    switch (trainingType) {
      case "cardio":
        return Icons.favorite;
      case "power":
        return Icons.fitness_center;
      case "legs":
        return Icons.directions_run;
      case "abs":
        return Icons.sports_gymnastics;
      case "arms":
        return Icons.accessibility;
      case "back":
        return Icons.self_improvement;
      case "stretching":
        return Icons.accessibility_new;
      case "yoga":
        return Icons.self_improvement;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildTrainingTypeCard(
      BuildContext context, String title, IconData icon, String trainingType) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChoosingOfTrainingScreen(
              trainingType: trainingType,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 200, 255),
              Color.fromARGB(255, 230, 150, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.black54,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
