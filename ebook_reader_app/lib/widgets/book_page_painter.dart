import 'package:flutter/material.dart';

class BookPagePainter extends CustomPainter {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;

  BookPagePainter({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          height: 1.5,
          fontFamily: 'Roboto',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
    );

    textPainter.layout(maxWidth: size.width - 40);
    textPainter.paint(canvas, const Offset(20, 20));
  }

  @override
  bool shouldRepaint(BookPagePainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.textColor != textColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
