import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

class FileStorageService {
  final String fileName;

  File? _file;

  FileStorageService({required this.fileName});

  /// Инициализация файла
  Future<void> initializeFile() async {
    Directory appDocDir = await _getStorageDirectory();
    _file = File('${appDocDir.path}/$fileName');

    // Создаём файл, если его нет
    if (!await _file!.exists()) {
      await _file!.create(recursive: true);
    }
  }

  /// Получение директории для хранения данных
  Future<Directory> _getStorageDirectory() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      Directory appDir = Directory('${dir.path}/SimpleNotebook');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      return appDir;
    } catch (e) {
      print('Ошибка при определении директории: $e');
      return Directory.current;
    }
  }

  /// Чтение данных из файла
  Future<List<Map<String, dynamic>>> readData() async {
    try {
      if (_file == null) {
        throw Exception('Файл не инициализирован. Вызовите initializeFile().');
      }

      String contents = await _file!.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } catch (e) {
      print('Ошибка при чтении данных из файла: $e');
      return [];
    }
  }

  /// Сохранение данных в файл
  Future<void> saveData(List<Map<String, dynamic>> data) async {
    try {
      if (_file == null) {
        throw Exception('Файл не инициализирован. Вызовите initializeFile().');
      }

      String jsonString = jsonEncode(data);
      await _file!.writeAsString(jsonString);
    } catch (e) {
      print('Ошибка при сохранении данных в файл: $e');
    }
  }
}