import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class Button extends ButtonComponent {
  Button(
    String text,
    {
      super.size,
      super.onReleased,
      super.position,
    }) : super(
    button: ButtonBackground(Colors.blueAccent),
    buttonDown: ButtonBackground(Colors.blue.shade300),
    children: [
      TextComponent(
        text: text,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 0.5  * size!.y,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        position: size / 2.0,
        anchor: Anchor.center,
      ),
    ],
    anchor: Anchor.center,
  );

  static final Paint paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.blue.shade900;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, height), Radius.circular(0.3 * size.y)), paint);
    super.render(canvas);
  }
}

class ButtonBackground extends PositionComponent with HasAncestor<Button> {
  final _paint = Paint()..style = PaintingStyle.stroke;

  late double cornerRadius;

  ButtonBackground(Color color) {
    _paint.color = color;
  }

  @override
  void onMount() {
    super.onMount();
    size = ancestor.size;
    cornerRadius = 0.3 * size.y;
    _paint.strokeWidth = 0.05 * size.y;
  }

  late final _background = RRect.fromRectAndRadius(
    size.toRect(),
    Radius.circular(cornerRadius),
  );

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_background, _paint);
  }
}
