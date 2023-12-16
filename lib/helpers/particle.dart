import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../TicTacToe/tic_tac_toe_game.dart';
import '../TicTacToe/tic_tac_toe_world.dart';


// TODO replace with https://docs.flame-engine.org/1.0.0/particles.html

class Particle extends PositionComponent with HasGameReference<TicTacToeGame> {
  static final Vector2 gravity = Vector2(0, 0.05);
  static final Random random = Random();

  late double i = 0;
  late double j = 0;

  Vector2 vel = Vector2.zero();
  Vector2 acc = Vector2.zero();
  int lifeTime = 0;
  double radius = 0;
  late double maxLifeTime;
  late bool gravityEnabled;

  Particle(this.i, this.j, {super.position, this.maxLifeTime = 100, this.gravityEnabled = true}) : super(size: Vector2(20, 20)) {
    position = Vector2(i, j);
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);
    getRadius(1, 4);
    _paint.color = Color.fromARGB(255, r, g, b);
    priority = 101;
  }

  final Paint _paint = Paint()
    ..style = PaintingStyle.fill;


  double constrain(double v, double mini, double maxi) {
    return max(mini, min(maxi, v));
  }

  double mapOpacity(double value, double start1, double stop1, double start2, double stop2, {bool withinBounds = true}) {

  double newVal = (value - start1) / (stop1 - start1) * (stop2 - start2) + start2;

  if (!withinBounds) {
    return newVal;
  }

  if (start2 < stop2) {
    return constrain(newVal, start2, stop2);
  } else {
    return constrain(newVal, stop2, start2);
  }
}


  @override
  void render(Canvas canvas) {
    _paint.color = _paint.color.withAlpha((mapOpacity(lifeTime.roundToDouble(), 0, maxLifeTime, 255, 0)).toInt());
    canvas.drawCircle(Offset.zero, radius, _paint);

    super.render(canvas);
  }

  void getRadius(min, max) {
    assert(min > 0, "Min Radius has to be > 0");
    radius = (random.nextInt(max) + min).roundToDouble();
  }

  void addForce(Vector2 force) {
    acc += force;
  }

  @override
  void update(double dt) {
    if (gravityEnabled) addForce(gravity);
    vel += acc * (1 + dt);
    position += vel;
    acc = Vector2.zero();

    lifeTime += 1;
    if (lifeTime >= maxLifeTime || !TicTacToeWorld.board.hasWon) {
      game.world.remove(this);
    }

    super.update(dt);
  }
}