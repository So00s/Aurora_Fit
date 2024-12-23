import 'package:flutter/material.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/pages/training_selection_page.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/models/training.dart';
import 'package:collection/collection.dart';


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

  void _addTimeToDay(String day, String time) {
    setState(() {
      _fitnessData?.schedule[day]?.add(TrainingSlot(time: time));
    });
    _saveData();
  }

  void _navigateToTrainingSelection(String day, String time) async {
  final selectedTraining = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TrainingSelectionPage(
        selectedTime: time,
        categoryKey: day,
      ),
    ),
  );

  if (selectedTraining != null && selectedTraining is Training) {
    setState(() {
      var slot = _fitnessData?.schedule[day]?.firstWhereOrNull(
        (slot) => slot.time == time,
      );
      if (slot != null) {
        slot.training = selectedTraining;
      }
    });
    _saveData();
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
                  onAddTime: (time) {
                    _addTimeToDay(day, time);
                  },
                  onSelectSlot: (slot) {
                    _navigateToTrainingSelection(day, slot.time);
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
  final Function(String) onAddTime; // Добавить время
  final Function(TrainingSlot) onSelectSlot; // Выбрать слот

  const DaySchedule({
    Key? key,
    required this.day,
    required this.slots,
    required this.onAddTime,
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
                title: Text(slot.time),
                subtitle: slot.training != null
                    ? Text(slot.training!.name)
                    : const Text('Тренировка не выбрана'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onSelectSlot(slot),
                ),
              );
            }).toList(),
            TextButton.icon(
              onPressed: () {
                _showTimePicker(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить время'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: List.generate(24, (hour) {
            String time = '${hour.toString().padLeft(2, '0')}:00';
            return ListTile(
              title: Text(time),
              onTap: () {
                Navigator.pop(context);
                onAddTime(time);
              },
            );
          }),
        );
      },
    );
  }
}
