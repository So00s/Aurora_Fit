import 'package:aurora_fit/pages/aurora_first_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/classes/button.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AuroraRefPage extends StatefulWidget {
  const AuroraRefPage({super.key});

  @override
  _AuroraRefPageState createState() => _AuroraRefPageState();
}

class _AuroraRefPageState extends State<AuroraRefPage> {
  int _count = 0;
  List<Map<String, dynamic>> _data = [];
  late File _file;

  @override
  void initState() {
    super.initState();
    _initializeFile();
  }

  Future<void> _initializeFile() async {
    Directory appDocDir = await _getStorageDirectory();
    _file = File('${appDocDir.path}/data.json');
    if (await _file.exists()) {
      String contents = await _file.readAsString();
      if (contents.isNotEmpty) {
        setState(() {
          _data = List<Map<String, dynamic>>.from(jsonDecode(contents));
        });
      }
    } else {
      await _file.create(recursive: true);
    }
  }

  Future<Directory> _getStorageDirectory() async {
    try {
      Directory dir = await getApplicationSupportDirectory();
      return dir;
    } catch (e) {
      print('Ошибка при определении директории: $e');
      return Directory.current;
    }
  }

  Future<void> _saveData() async {
    try {
      String jsonString = jsonEncode(_data);
      await _file.writeAsString(jsonString);
      print('Данные успешно сохранены!');
    } catch (e) {
      print('Ошибка при сохранении данных: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      if (await _file.exists()) {
        String contents = await _file.readAsString();
        setState(() {
          _data = List<Map<String, dynamic>>.from(jsonDecode(contents));
        });
        print('Данные успешно загружены!');
      }
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AURORA FIT на одной строке
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'AURORA ',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                      letterSpacing: 2,
                    ),
                  ),
                  TextSpan(
                    text: 'FIT',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            // Логотип на следующей строке
            const Icon(
              Icons.signal_cellular_alt_rounded,
              color: Colors.deepOrange,
              size: 50,
            ),
            // Линия и текст
            const Column(
              children: [
                Divider(thickness: 1, color: Colors.black26, indent: 50, endIndent: 50),
                Text(
                  'Ваш персональный тренер',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: Colors.deepOrange,
                  ),
                ),
                Divider(thickness: 1, color: Colors.black26, indent: 50, endIndent: 50),
              ],
            ),
            // Звёзды прогресса
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 40),
                    Icon(Icons.star, color: Colors.orange, size: 40),
                    Icon(Icons.star_border, color: Colors.grey, size: 40),
                    Icon(Icons.star_border, color: Colors.grey, size: 40),
                    Icon(Icons.star_border, color: Colors.grey, size: 40),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Ваш прогресс за неделю\n(2 из 5 звёзд)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Текущий счётчик
            Text(
              'Текущий счёт: $_count',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Кнопки управления
            GradientButton(
              text: 'Продолжить',
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
            ),
            GradientButton(
              text: 'Сохранить',
              onPressed: () {
                _data = [{'count': _count}];
                _saveData();
              },
            ),
            GradientButton(
              text: 'Загрузить данные',
              onPressed: () {
                _loadData().then((_) {
                  if (_data.isNotEmpty) {
                    setState(() {
                      _count = _data.first['count'] ?? 0;
                    });
                  }
                });
              },
            ),
            GradientButton(
              text: 'Назад',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuroraFirstPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}