import 'package:flutter/material.dart';
import 'package:aurora_fit/services/fitness_data_service.dart';
import 'package:aurora_fit/pages/training_selection_page.dart';
import 'package:aurora_fit/models/exercise.dart' as ex; // Псевдоним для Exercise
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/models/types.dart'; 
import 'package:aurora_fit/classes/gradient_button.dart'; 
import 'package:aurora_fit/pages/start_training_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AuroraTrainigTypesPage extends StatefulWidget {
  const AuroraTrainigTypesPage({Key? key}) : super(key: key);
  @override 
   _AuroraTrainigTypesPageState createState() => _AuroraTrainigTypesPageState();
}

class FitnessButton extends StatelessWidget{
  final String text;
  

}

class _AuroraTrainigTypesPageState extends State<AuroraTrainigTypesPage>{
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
          child: 
            
        )
    );
  }
}