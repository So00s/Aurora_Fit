// lib/classes/fractional_stars.dart

import 'package:flutter/material.dart';

class FractionalStars extends StatelessWidget {
  final double rating; // Рейтинг от 0 до 5
  final int starCount;
  final double size;
  final Color filledColor;
  final Color unfilledColor;

  const FractionalStars({
    Key? key,
    required this.rating,
    this.starCount = 5,
    this.size = 40,
    this.filledColor = Colors.orange,
    this.unfilledColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: filledColor, size: size);
        } else if (index == fullStars && hasHalfStar) {
          return Stack(
            children: [
              Icon(Icons.star_border, color: unfilledColor, size: size),
              ClipRect(
                clipper: _HalfClipper(),
                child: Icon(Icons.star, color: filledColor, size: size),
              ),
            ],
          );
        } else {
          return Icon(Icons.star_border, color: unfilledColor, size: size);
        }
      }),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
