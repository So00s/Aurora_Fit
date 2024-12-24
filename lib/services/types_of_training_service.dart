// lib/services/types_of_training_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/types_of_trainings.dart';

class TypesOfDataService {
  final String _fileName = 'types_of_training.json';

  Future<TypesOfTrainings> loadFitnessData() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString);
        return TypesOfTrainings.fromJson(jsonData);
      } else {
        // Если файл не существует, загрузите данные из assets
        String assetString =
            await rootBundle.loadString('lib/json/types_of_training.json');
        final jsonData = jsonDecode(assetString);
        TypesOfTrainings fitnessData = TypesOfTrainings.fromJson(jsonData);
        await saveFitnessData(fitnessData); // Сохраняем начальные данные
        return fitnessData;
      }
    } catch (e, stackTrace) {
      print('Ошибка при загрузке данных: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Не удалось загрузить данные');
    }
  }

  Future<void> saveFitnessData(TypesOfTrainings data) async {
    try {
      final file = await _getLocalFile();
      String jsonString = jsonEncode(data.toJson());
      await file.writeAsString(jsonString);
      print('Данные успешно сохранены');
    } catch (e) {
      print('Ошибка при сохранении данных: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$_fileName');
  }
}
