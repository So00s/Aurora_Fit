//lib/pages/choosing_type_of_training.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:aurora_fit/services/fitness_data_service.dart";
import 'package:aurora_fit/models/exercise.dart' as ex;
import 'package:aurora_fit/models/training.dart';
import 'package:aurora_fit/models/fitness_data.dart';
import 'package:aurora_fit/pages/choosing_of_training_screen.dart';



class ChoosingTypeOfTrainingScreen extends StatefulWidget{

  const ChoosingTypeOfTrainingScreen({Key? key}): super(key: key);

  @override
  _ChooseTrainingTypeState createState() => _ChooseTrainingTypeState();
}

class _ChooseTrainingTypeState extends State<ChoosingTypeOfTrainingScreen>{
  late Future<FitnessData> _fitnessDataFuture;
  FitnessData? _fitnessData;

  @override
  void initState() {
    super.initState();
    _fitnessDataFuture = FitnessDataService().loadFitnessData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: 
        Text(
          'AURORA',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 239, 85, 8),
          ),
        ),
      );
  }
}