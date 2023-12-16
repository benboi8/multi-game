import 'dart:async' as async;
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_game.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_world.dart';
import 'package:test_game/helpers/particle.dart';

import 'box.dart';

enum Player { o, x, none }

enum WinStyle { one, two, three }

class TicTacToeBoard extends PositionComponent
    with HasGameReference<TicTacToeGame> {
  static final cellSize = Vector2(100, 100);

  static final xPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = const Color.fromARGB(255, 0, 150, 255);

  static final oPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = const Color.fromARGB(255, 255, 50, 150);

  static final Random random = Random();
  static final int numOfWinParticles = TicTacToeWorld.numOfWinParticles;

  Player player = Player.x;

  List<Box> boxes = [];
  Offset winPoint1 = Offset.zero;
  Offset winPoint2 = Offset.zero;
  Paint winnerPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round;

  bool hasWon = false;
  bool allowInputs = true;
  WinStyle winStyle = WinStyle.three;

  TicTacToeBoard({super.position}) : super(size: TicTacToeBoard.cellSize * 3) {
    position = Vector2(0, 0);
  }

  @override
  void render(Canvas canvas) {
    if (hasWon) {
      canvas.drawLine(winPoint1, winPoint2, winnerPaint);
    }
  }

  int _numOfXWins = 0;
  int _numOfOWins = 0;
  int _numOfDraws = 0;

  String xWins() {
    return "$_numOfXWins";
  }

  String oWins() {
    return "$_numOfOWins";
  }

  String draws() {
    return "$_numOfDraws";
  }

  void restart() {
    for (Box box in boxes) {
      box.empty = true;
      box.isX = false;
    }
    hasWon = false;
    winPoint1 = Offset.zero;
    winPoint2 = Offset.zero;
    allowInputs = true;
  }

  void makeBoard(Vector2 mid, TicTacToeWorld world) {
    for (double i = 0; i < 3; i++) {
      for (double j = 0; j < 3; j++) {
        Box box = Box(
            mid.x + (i * cellSize.x) - cellSize.x * 1.5,
            mid.y +
                (j * cellSize.y) -
                cellSize.y * 1.5 -
                TicTacToeWorld.padding.y);
        world.add(box);
        boxes.add(box);
      }
    }
    position = boxes[0].position;
  }

  void checkWin() {
    for (int i = 0; i <= 6; i += 3) {
      // Vertical
      if (boxes[i].value == boxes[i + 1].value &&
          boxes[i + 1].value == boxes[i + 2].value &&
          boxes[i + 2].value != Player.none) {
        win();
        setWinner(i, i + 2, boxes[i].value);
      }
    }
    for (int i = 0; i < 3; i++) {
      // Horizontal
      if (boxes[i].value == boxes[i + 3].value &&
          boxes[i + 3].value == boxes[i + 6].value &&
          boxes[i + 6].value != Player.none) {
        setWinner(i, i + 6, boxes[i].value);
        win();
      }
    }
    // Diagonal
    if (boxes[0].value == boxes[4].value &&
        boxes[4].value == boxes[8].value &&
        boxes[8].value != Player.none) {
      win();
      setWinner(0, 8, boxes[4].value);
    }
    if (boxes[2].value == boxes[4].value &&
        boxes[4].value == boxes[6].value &&
        boxes[6].value != Player.none) {
      win();
      setWinner(2, 6, boxes[4].value);
    }
    //
    // for (Box box in boxes) {
    //   if (box.empty) break;
    //   print(box.empty);
    //   draw();
    // }
  }

  void draw() {
    hasWon = false;
    allowInputs = false;
    _numOfDraws++;
  }

  void setWinner(int i, int j, Player winner) {
    winPoint1 = Offset(-(position.x - (boxes[i].position.x + cellSize.x / 2)),
        -(position.y - (boxes[i].position.y + cellSize.y / 2)));
    winPoint2 = Offset(-(position.x - (boxes[j].position.x + cellSize.x / 2)),
        -(position.y - (boxes[j].position.y + cellSize.y / 2)));
    winnerPaint.color = winner == Player.x ? xPaint.color : oPaint.color;
    winnerPaint.color = winnerPaint.color.withOpacity(0.8);
    winner == Player.x ? _numOfXWins++ : _numOfOWins++;
  }

  void win() {
    priority = 100;
    hasWon = true;
    allowInputs = false;
    showParticles();
  }

  void showParticles() {
    void Function(int amount) createParticles = (int amount) {};
    switch (winStyle) {
      case WinStyle.two:
        createParticles = (int amount) {
          for (int i = 0; i < amount; i++) {
            Particle p = Particle(boxes[4].position.x + cellSize.x / 2,
                boxes[4].position.y + cellSize.y / 2,
                maxLifeTime: 275);
            double x = (random.nextDouble() - 0.5) * 2;
            double y = (random.nextDouble() - 0.5);
            Vector2 force = Vector2(x, -5 + y);
            p.addForce(force);
            game.world.add(p);
          }
        };
      case WinStyle.three:
        createParticles = (int amount) {
          for (int i = 0; i < amount; i++) {
            Particle p = Particle(boxes[4].position.x + cellSize.x / 2,
                boxes[4].position.y + cellSize.y / 2,
                gravityEnabled: false, maxLifeTime: 400);

            double x = (random.nextDouble() - 0.5) * 0.7;
            double y = (random.nextDouble() - 0.5) * 0.7;
            Vector2 force = Vector2(sin(x + i), cos(y + i));
            p.addForce(force);

            game.world.add(p);
          }
        };
      case WinStyle.one:
      default:
        createParticles = (int amount) {
          for (int i = 0; i < amount; i++) {
            Particle p = Particle(boxes[4].position.x + cellSize.x / 2,
                boxes[4].position.y + cellSize.y / 2);
            p.addForce((Vector2.random() + Vector2(-0.5, -0.5)) * 8);
            game.world.add(p);
          }
        };
    }

    createParticles(numOfWinParticles);
    async.Timer timer =
        async.Timer.periodic(const Duration(milliseconds: 250), (timer) {
      createParticles(numOfWinParticles);
      if (!hasWon) {
        timer.cancel();
      }
    });
    Future.delayed(const Duration(seconds: 10), () {
      timer.cancel();
    });
  }
}
