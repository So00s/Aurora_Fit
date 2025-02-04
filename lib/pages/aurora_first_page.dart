// lib/pages/aurora_first_page.dart

import 'package:aurora_fit/pages/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/classes/gradient_button.dart';
import 'package:aurora_fit/classes/fractional_stars.dart';
import 'package:aurora_fit/models/fitness_data.dart'; 
import 'package:aurora_fit/services/fitness_data_service.dart';

class AuroraFirstPage extends StatefulWidget {
  const AuroraFirstPage({Key? key}) : super(key: key);

  @override
  _AuroraFirstPageState createState() => _AuroraFirstPageState();
}

class _AuroraFirstPageState extends State<AuroraFirstPage> {
  double _progress = 0.0; // Начальное значение прогресса
  late FitnessData _fitnessData;

  final FitnessDataService _fitnessDataService = FitnessDataService();

  @override
  void initState() {
    super.initState();
    _loadFitnessData();
  }

  // Метод для загрузки данных
  Future<void> _loadFitnessData() async {
    try {
      // Загружаем данные с помощью сервиса
      FitnessData fitnessData = await _fitnessDataService.loadFitnessData();
      setState(() {
        _fitnessData = fitnessData;
        // Вычисляем прогресс на основе загруженных данных
        _progress = _fitnessData.calculateProgress();
      });
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
      // В случае ошибки можно установить прогресс в 0 или отобразить ошибку
      setState(() {
        _progress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                'assets/images/full.png',
                width: 100,
                height: 100,
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
                      fontWeight: FontWeight.w500,
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
                    rating: _progress,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ваш прогресс за неделю',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                    MaterialPageRoute(builder: (context) => const ChoosingTypeOfTrainingScreen()),
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}