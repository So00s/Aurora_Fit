// lib/services/fitness_data_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/fitness_data.dart';

class FitnessDataService {
  final String _fileName = 'fitness_data.json';

  Future<FitnessData> loadFitnessData() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString);
        return FitnessData.fromJson(jsonData);
      } else {
        // Если файл не существует, загрузите данные из assets
        String assetString =
            await rootBundle.loadString('lib/json/fitness_data.json');
        final jsonData = jsonDecode(assetString);
        FitnessData fitnessData = FitnessData.fromJson(jsonData);
        await saveFitnessData(fitnessData); // Сохраняем начальные данные
        return fitnessData;
      }
    } catch (e, stackTrace) {
      print('Ошибка при загрузке данных: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Не удалось загрузить данные');
    }
  }

  Future<void> saveFitnessData(FitnessData data) async {
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
