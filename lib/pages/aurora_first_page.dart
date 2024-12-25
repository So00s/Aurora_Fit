// lib/pages/aurora_first_page.dart

import 'package:flutter/material.dart';
import 'package:aurora_fit/pages/schedule_screen.dart';
import 'package:aurora_fit/pages/aurora_training_types_page.dart';
import 'package:aurora_fit/classes/gradient_button.dart';
import 'package:aurora_fit/classes/fractional_stars.dart';
import 'package:aurora_fit/pages/training_description_screen.dart';
import 'package:aurora_fit/pages/choosing_of_training_screen.dart';
import 'package:aurora_fit/pages/choosing_type_of_training_screen.dart';

class AuroraFirstPage extends StatefulWidget {
  const AuroraFirstPage({Key? key}) : super(key: key);

  @override
  _AuroraFirstPageState createState() => _AuroraFirstPageState();
}

class _AuroraFirstPageState extends State<AuroraFirstPage> {
  double _progress = 2.0; // Начальное значение прогресса

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0), // Добавляем отступы по горизонтали
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // AURORA FIT на одной строке
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'AURORA ',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 239, 85, 8),
                        letterSpacing: 2,
                      ),
                    ),
                    TextSpan(
                      text: 'FIT',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 4, 185),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              // Логотип на следующей строке
              Image.asset(
                'assets/images/full.png', // Путь к вашему изображению
                width: 100, // Ширина изображения
                height: 100, // Высота изображения
              ),
              // Линия и текст
              const Column(
                children: [
                  Divider(
                      thickness: 1,
                      color: Colors.black26,
                      indent: 50,
                      endIndent: 50),
                  Text(
                    'Ваш персональный тренер',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: Color.fromARGB(255, 239, 85, 8),
                      fontWeight: FontWeight.w500, // Средний вес текста
                    ),
                  ),
                  Divider(
                      thickness: 1,
                      color: Colors.black26,
                      indent: 50,
                      endIndent: 50),
                ],
              ),
              // Звёзды прогресса
              Column(
                children: [
                  FractionalStars(
                    rating: _progress, // Используем переменную прогресса
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ваш прогресс за неделю\n(${_progress.toStringAsPrecision(2)} из 5 звёзд)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Градиентная кнопка
              GradientButton(
                text: 'Продолжить',
                onPressed: () {
                  // Переход на ScheduleScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                  );
                },
              ),
              const SizedBox(height: 50),
              // Пример кнопки для увеличения прогресса (для тестирования)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _progress += 0.1;
                    if (_progress > 5.0) _progress = 5.0;
                  });
                },
                child: const Text('Увеличить прогресс'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
