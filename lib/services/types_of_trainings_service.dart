import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/types_of_trainings.dart';

class TypesOfTrainingsService {
  final String _fileName = 'all_workouts.json';

  Future<TypesOfTrainings> loadTrainings() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString);
        return TypesOfTrainings.fromJson(jsonData);
      } else {
        // Если файл не существует, загружаем из assets
        String assetString =
            await rootBundle.loadString('lib/json/all_workouts.json');
        final jsonData = jsonDecode(assetString);
        TypesOfTrainings typesOfTrainings = TypesOfTrainings.fromJson(jsonData);
        await saveTrainings(typesOfTrainings); // Сохраняем для использования
        return typesOfTrainings;
      }
    } catch (e, stackTrace) {
      print('Ошибка при загрузке данных: $e');
      print(stackTrace);
      throw Exception('Не удалось загрузить тренировки');
    }
  }

  Future<void> saveTrainings(TypesOfTrainings data) async {
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
