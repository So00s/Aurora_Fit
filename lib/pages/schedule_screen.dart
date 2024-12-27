//lib/pages/schedule_screen.dart

import 'package:aurora_fit/classes/gradient_button.dart';
import 'package:aurora_fit/pages/aurora_first_page.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/pages/choosing_type_of_training_screen.dart';
import 'package:aurora_fit/pages/start_training_page.dart';
import 'package:aurora_fit/services/found_workout.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;
  final FitnessDataService _fitnessDataService = FitnessDataService();
  final WorkoutService _workoutService = WorkoutService();
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



  void _navigateToStartTraining(String day, TrainingSlot slot) async {
    final training = await _workoutService.findTraining(slot.category, slot.workout.name);

    if (training != null) {
      final isCompleted = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StartTrainingPage(training: training),
        ),
      );

      if (isCompleted == true) {
        // Обновляем статус тренировки
        setState(() {
          slot.isCompleted = true;
        });

        // Сохраняем обновленные данные
        _saveData();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось найти тренировку')),
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AuroraFirstPage()),);
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
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
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
            
            return Column(
              children: [
                // Список тренировок
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: _fitnessData!.schedule.entries.map((entry) {
                      return DaySchedule(
                        day: entry.key,
                        slots: entry.value,
                        onChooseTraining: (day) {
                          _openChoosingTypeOfTrainingScreen(day);
                        },
                        onSelectSlot: (slot) {
                          _navigateToStartTraining(entry.key, slot);
                        },
                      );
                    }).toList(),
                  ),
                ),
                // Кнопка внизу
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Прозрачный фон
                    ),
                    child: GradientButton(
                      text: "Начать заново",
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Начать заново')),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
  final Function(TrainingSlot) onSelectSlot;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок дня с кнопками
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Кнопка "изм." нажата')),
                    );
                  },
                  icon: const Icon(Icons.edit,
                    color: Colors.black,),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => onChooseTraining(day),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...slots.map((slot) {
              return Column(
                children: [
                  Row(
                    children: [
                      // Время и категория
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.begintime.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            FutureBuilder<String>(
                              future: WorkoutService().getCategoryTitle(slot.category),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Загрузка...');
                                } else if (snapshot.hasError) {
                                  return const Text('Ошибка');
                                } else {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(fontSize: 16),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // Время + калории + статус
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${slot.workout.duration} мин',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${slot.workout.calories} Ккал',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          slot.isCompleted
                              ? ElevatedButton(
                                  onPressed: (){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Вы большой молодец!')),
                                      );
                                    },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 192, 255, 200),
                                    side: const BorderSide( // Добавляем обводку
                                      color: Color(0x00000021), // Цвет обводки
                                      width: 2, // Толщина обводки
                                    ),
                                  ),
                                  child: const Text('выполнено', style: TextStyle(color: Colors.black),),
                                )
                              : ElevatedButton(
                                  onPressed: () => onSelectSlot(slot),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xEFEFEFFF),
                                    side: const BorderSide( // Добавляем обводку
                                      color: Color(0x00000021), // Цвет обводки
                                      width: 2, // Толщина обводки
                                    ),
                                  ),
                                  child: const Text('начать', style: TextStyle(color: Colors.grey),),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                ],
              );
            }).toList(),
            if (slots.isEmpty)
              const Center(
                child: Text(
                  'Пока что тренировок нет...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
