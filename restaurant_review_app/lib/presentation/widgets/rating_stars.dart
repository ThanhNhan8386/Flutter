import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final Color color;
  final bool interactive;
  final Function(int)? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 24,
    this.color = Colors.amber,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < rating;
        return interactive
            ? IconButton(
                icon: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  color: color,
                  size: size,
                ),
                onPressed: () => onRatingChanged?.call(index + 1),
              )
            : Icon(
                isFilled ? Icons.star : Icons.star_border,
                color: color,
                size: size,
              );
      }),
    );
  }
}
