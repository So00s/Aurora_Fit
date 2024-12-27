import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aurora_fit/models/exercise.dart';
import 'package:aurora_fit/models/training.dart';

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
              Navigator.pop(context); // Закрываем диалог
              Navigator.pop(context, true); // Передаем результат завершения
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
    if (_currentExerciseIndex < widget.training.exercises.length) {
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
    Exercise currentExercise = widget.training.exercises[_currentExerciseIndex];
    return Scaffold(
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
                icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 239, 85, 8)),
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
                    Text(
                      currentExercise.name,
                      style: const TextStyle(
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
            // Круглый таймер с прогрессом (увеличим размер)
            SizedBox(
              width: 200, // Увеличим размер
              height: 200, // Увеличим размер
              child: CircularProgressIndicator(
                value: _remainingSeconds / _parseTime(currentExercise.time),
                strokeWidth: 12.0, // Сделаем стрелку толще
                valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 239, 85, 8)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Кнопки
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
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Стоп',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _isRest ? 'Далее' : 'Перерыв',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
