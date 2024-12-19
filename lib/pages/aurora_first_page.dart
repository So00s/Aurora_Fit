import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aurora_fit/classes/button.dart';

class AuroraFirstPage extends StatelessWidget {
  const AuroraFirstPage({super.key});
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
              text: TextSpan(
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
            Icon(
              Icons.signal_cellular_alt_rounded,
              color: Colors.deepOrange,
              size: 50,
            ),
            // Линия и текст
            Column(
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
            Column(
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
            // Градиентная кнопка
            GradientButton(
              text: 'Продолжить',
              onPressed: () {
                print('Кнопка нажата!');
              },
            ),
          ],
        ),
      ),
    );
  }
}