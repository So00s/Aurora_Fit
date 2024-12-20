import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/classes/button.dart';
import 'aurora_ref.dart';
import 'package:image_picker/image_picker.dart';



class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
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
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255,239, 85, 8)),
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
                        'Расписание тренировок',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255,100, 4, 185),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Общий отступ для экрана
          child: Column(
            children: const [
              // Понедельник
              DaySchedule(
                day: 'Понедельник',
                times: ['8:00', '13:00', '18:00'],
                color: Color.fromARGB(255, 255, 214, 199),
              ),
              // Вторник
              DaySchedule(
                day: 'Вторник',
                times: ['10:00'],
                color: Color.fromARGB(155, 239, 85, 8),
              ),
              // Среда
              DaySchedule(
                day: 'Среда',
                times: [],
                color: Color.fromARGB(155, 255, 124, 121),
              ),
              // Четверг
              DaySchedule(
                day: 'Четверг',
                times: [],
                color: Color.fromARGB(112, 241, 88, 239),
              ),
              // Пятница
              DaySchedule(
                day: 'Пятница',
                times: [],
                color: Color.fromARGB(112, 236, 198, 225),
              ),
              // Суббота
              DaySchedule(
                day: 'Суббота',
                times: [],
                color: Color.fromARGB(112, 201, 163, 232),
              ),
              // Воскресенье
              DaySchedule(
                day: 'Воскресенье',
                times: [],
                color: Color.fromARGB(92, 41, 0, 191),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DaySchedule extends StatelessWidget {
  final String day;
  final List<String> times;
  final Color color;

  const DaySchedule({super.key, required this.day, required this.times, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:Alignment.center,
      margin: const EdgeInsets.only(bottom: 16.0), // Отступ между блоками
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color, // Цвет фона контейнера
              borderRadius: BorderRadius.circular(14.0), // Скругленные углы
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              day,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: times.map((time) {
              return ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(time, style: const TextStyle(fontSize: 16)),
                trailing: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
              );
            }).toList(),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Добавить'),
            onTap: () {
              // Логика добавления времени
            },
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }
}
