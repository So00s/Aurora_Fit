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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        double starFill = (rating - index).clamp(0, 1);
        return Stack(
          children: [
            Icon(Icons.star_border, color: unfilledColor, size: size),
            ClipRect(
              clipper: _PartialStarClipper(fillPercentage: starFill),
              child: Icon(Icons.star, color: filledColor, size: size),
            ),
          ],
        );
      }),
    );
  }
}

class _PartialStarClipper extends CustomClipper<Rect> {
  final double fillPercentage; // Значение от 0 до 1

  _PartialStarClipper({required this.fillPercentage});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width * fillPercentage, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
