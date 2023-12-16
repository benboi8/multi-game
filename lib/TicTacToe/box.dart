import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_board.dart';

import 'tic_tac_toe_game.dart';
import 'tic_tac_toe_world.dart';

class Box extends PositionComponent
    with TapCallbacks, HasGameReference<TicTacToeGame> {
  static final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..color = const Color.fromARGB(255, 175, 175, 175);

  static final _xPaint = TicTacToeBoard.xPaint;
  static final _oPaint = TicTacToeBoard.oPaint;
  static final board = TicTacToeWorld.board;

  Player get value => empty
      ? Player.none
      : isX
          ? Player.x
          : Player.o;

  final w = TicTacToeBoard.cellSize.x;
  final h = TicTacToeBoard.cellSize.y;

  late RRect boxRect;

  double i;
  double j;
  Box(this.i, this.j, {super.position}) : super(size: TicTacToeBoard.cellSize) {
    position = Vector2(i, j);
    boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(10.0),
    );
  }

  bool isX = false;
  bool empty = true;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(boxRect, _borderPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h),
          const Radius.circular(3.0),
        ),
        _borderPaint);

    if (isX) {
      canvas.drawLine(const Offset(10, 10), Offset(w - 10, h - 10), _xPaint);
      canvas.drawLine(Offset(w - 10, 10), Offset(10, h - 10), _xPaint);
    } else if (!empty) {
      canvas.drawCircle(Offset(w / 2, h / 2), w / 2 - 10, _oPaint);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!board.allowInputs) return;
    if (!empty) return;

    super.onTapUp(event);

    place();
    hasWon();
  }

  void place() {
    empty = false;
    if (board.player == Player.x) {
      isX = true;
      board.player = Player.o;
    } else if (board.player == Player.o) {
      board.player = Player.x;
    }
  }

  void hasWon() {
    board.checkWin();
  }
}
