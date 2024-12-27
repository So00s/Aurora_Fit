//lib/pages/choosing_type_of_training.dart

import 'package:aurora_fit/services/types_of_trainings_service.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/pages/choosing_of_training_screen.dart';
import 'package:aurora_fit/models/types_of_trainings.dart';




class ChoosingTypeOfTrainingScreen extends StatefulWidget {
  final String dayOfWeek;

  const ChoosingTypeOfTrainingScreen({
    Key? key,
    required this.dayOfWeek,
  }) : super(key: key);

  @override
  _TrainingTypeSelectionScreenState createState() => _TrainingTypeSelectionScreenState();
}

class _TrainingTypeSelectionScreenState extends State<ChoosingTypeOfTrainingScreen> {
  late Future<TypesOfTrainings> _fitnessDataFuture;
  TypesOfTrainings? _fitnessData;
  
  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = TypesOfTrainingsService().loadTrainings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
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
                  const Text(
                    'Типы тренировок',
                    style: TextStyle(
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
              dayOfWeek: widget.dayOfWeek,
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
