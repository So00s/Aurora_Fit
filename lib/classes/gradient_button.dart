// lib/classes/gradient_button.dart

import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Кнопка будет растягиваться на всю доступную ширину
      height: 50, // Фиксированная высота
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 239, 85, 8),
                Color.fromARGB(255, 100, 4, 185),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Уменьшенный размер для среднего текста
              fontWeight: FontWeight.w500, // Средний вес текста
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
