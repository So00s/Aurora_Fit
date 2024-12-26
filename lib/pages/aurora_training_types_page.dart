import 'package:flutter/material.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/pages/training_selection_page.dart';
import 'package:aurora_fit/models/exercise.dart' as ex; // Псевдоним для Exercise
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/classes/gradient_button.dart'; 
import 'package:aurora_fit/pages/start_training_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AuroraTrainingTypesPage extends StatefulWidget {
  const AuroraTrainingTypesPage({Key? key}) : super(key: key);
  @override 
   _AuroraTrainingTypesPageState createState() => _AuroraTrainingTypesPageState();
}

class FitnessButton extends StatelessWidget{
  final String text;
  final Color color1, color2;
  final Image icon;
  final VoidCallback onPressed;

  const FitnessButton({
    Key? key,
    required this.text,
    required this.color1,
    required this.color2,
    required this.icon,
    required this.onPressed,
  }) :super (key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, // Фиксированная ширина
      height: 160, // Фиксированная высота
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [ 
              Text(
                text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Уменьшенный размер для среднего текста
                fontWeight: FontWeight.w500, // Средний вес текста
              ),
              textAlign: TextAlign.center,
            ),
            icon,
            ],
          ),
        ),
      ),
    );
  }
}


class _AuroraTrainingTypesPageState extends State<AuroraTrainingTypesPage>{
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;
  final FitnessDataService _fitnessDataService = FitnessDataService();
  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = _fitnessDataService.loadFitnessData();
  }
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Увеличиваем высоту AppBar
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          automaticallyImplyLeading: false, // Убираем стандартный отступ для стрелки
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 0.0), // Отступ сверху
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Color.fromARGB(255, 239, 85, 8)),
                  onPressed: () {
                    Navigator.pop(context); // Возврат на предыдущий экран
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FitnessButton(text: "Тип тренировки",
          color1: Color.fromRGBO(134, 4, 255, 0.17),
          color2:  Color.fromRGBO(195, 0, 255, 0.53),
          icon: Image.asset(
                'assets/images/full.png', // Путь к вашему изображению
                width: 89, // Ширина изображения
                height: 70, // Высота изображения
              ),
          onPressed: (){} ,)
        )
    );
  }
}
