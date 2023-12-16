import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Label extends TextComponent {
  late String label;
  late Function value;

  Label(
      this.label,
      this.value,
  {
    super.size,
    super.position,
  }) : super(
    text: label,
    textRenderer: TextPaint(
      style: TextStyle(
        fontSize: 0.5  * size!.y,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
    ),
  );

  static final Paint _paintBorder = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.blue;

  static final Paint _paintBackground = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.blue.shade900;

  @override
  void render(Canvas canvas) {
    double w = width + 30;
    double h = height + 30;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.x / 2, size.y / 2), width: w, height: h), const Radius.circular(15)), _paintBorder);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.x / 2, size.y / 2), width: w, height: h), const Radius.circular(15)), _paintBackground);

    String newText = value.call();
    text = label + newText;

    super.render(canvas);
  }
}