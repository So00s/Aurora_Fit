// lib/pages/start_training_page.dart

import 'package:flutter/material.dart';
import 'package:aurora_fit/models/exercise.dart';
import 'package:aurora_fit/models/training.dart';
import 'dart:async';

class StartTrainingPage extends StatefulWidget {
  final Training training;

  const StartTrainingPage({Key? key, required this.training}) : super(key: key);

  @override
  _StartTrainingPageState createState() => _StartTrainingPageState();
}

class _StartTrainingPageState extends State<StartTrainingPage> {
  int _currentExerciseIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRest = false;

  @override
  void initState() {
    super.initState();
    _startExercise(widget.training.exercises[_currentExerciseIndex]);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startExercise(Exercise exercise) {
    setState(() {
      _remainingSeconds = _parseTime(exercise.time);
      _isRest = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _showNextStep();
      }
    });
  }

  void _startRest() {
    setState(() {
      _remainingSeconds = 15; // 15 секунд перерыва
      _isRest = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _nextExercise();
      }
    });
  }

  void _showNextStep() {
    if (_currentExerciseIndex < widget.training.exercises.length - 1) {
      _showRestDialog();
    } else {
      _showCompletionDialog();
    }
  }

  void _showRestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Перерыв'),
        content: const Text('15 секунд перерыва перед следующим упражнением.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startRest();
            },
            child: const Text('Начать'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Тренировка завершена!'),
        content: const Text('Поздравляем! Вы завершили тренировку.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true); // Возвращаемся к расписанию с отметкой
            },
            child: const Text('Закрыть'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _nextExercise() {
    setState(() {
      _currentExerciseIndex++;
    });
    if (_currentExerciseIndex < widget.training.exercises.length - 1) {
      _startExercise(widget.training.exercises[_currentExerciseIndex]);
    } else {
      _showCompletionDialog();
    }
  }

  int _parseTime(String timeStr) {
    // Преобразуем строку времени "1:00" в секунды
    List<String> parts = timeStr.split(':');
    if (parts.length != 2) return 60; // По умолчанию 60 секунд
    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Exercise currentExercise =
        widget.training.exercises[_currentExerciseIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(currentExercise.name),
        backgroundColor: const Color.fromARGB(255, 239, 85, 8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentExercise.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              _isRest ? 'Перерыв' : 'Время упражнения',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.pop(context, false); // Возвращаемся без отметки
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Стоп'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    if (_isRest) {
                      _nextExercise();
                    } else {
                      _startRest();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: Text(_isRest ? 'Далее' : 'Перерыв'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
