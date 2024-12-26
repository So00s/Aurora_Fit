//lib/pages/schedule_screen.dart

import 'package:aurora_fit/pages/aurora_first_page.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/pages/training_selection_page.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/models/training.dart';
import 'package:collection/collection.dart';
import 'package:aurora_fit/pages/choosing_type_of_training_screen.dart';
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

  void _openChoosingTypeOfTrainingScreen(String day) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChoosingTypeOfTrainingScreen(dayOfWeek: day),
      ),
    );

    if (result == true) {
      setState(() {
        _fitnessDataFuture = _fitnessDataService.loadFitnessData(); // Обновляем данные
      });
    }
  }



  void _navigateToTrainingSelection(String day, String begintime) async {
    // Найти тренировку в расписании
    var slot = _fitnessData?.schedule[day]?.firstWhereOrNull(
      (slot) => slot.begintime == begintime,
    );

    if (slot != null && slot.workout != null) {
      final isCompleted = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuroraFirstPage(),
        ),
      );

      if (isCompleted == true) {
        // Обновить статус тренировки как завершенной
        setState(() {
          slot.isCompleted = true; // Предполагается, что есть поле isCompleted
        });
        _saveData();
      }
    } else {
      // Если тренировка не найдена
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет тренировки для этого времени')),
      );
    }
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
      appBar: AppBar(
        title: const Text('Расписание тренировок'),
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
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: _fitnessData!.schedule.entries.map((entry) {
                String day = entry.key; // День недели
                List<TrainingSlot> slots = entry.value; // Тренировки в этот день
                return DaySchedule(
                  day: day,
                  slots: slots,
                  onChooseTraining: (day) {
                    _openChoosingTypeOfTrainingScreen(day);
                  },
                  onSelectSlot: (slot) {
                    _navigateToTrainingSelection(day, slot.begintime);
                  },
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('Нет данных'));
          }
        },
      ),
    );
  }
}

class DaySchedule extends StatelessWidget {
  final String day;
  final List<TrainingSlot> slots;
  final Function(String) onChooseTraining;
  final Function(TrainingSlot) onSelectSlot; // Выбрать слот

  const DaySchedule({
    Key? key,
    required this.day,
    required this.slots,
    required this.onChooseTraining,
    required this.onSelectSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...slots.map((slot) {
              return ListTile(
                title: Text(slot.begintime),
                subtitle: slot.workout != null
                    ? Text(slot.workout!.name)
                    : const Text('Тренировка не выбрана'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onSelectSlot(slot),
                ),
              );
            }).toList(),
            TextButton.icon(
              onPressed: () {
                onChooseTraining(day);
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить тренировку'),
            ),
          ],
        ),
      ),
    );
  }
}
