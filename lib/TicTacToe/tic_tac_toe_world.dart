import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_board.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_game.dart';
import 'package:test_game/helpers/label.dart';

import '../helpers/button.dart';

enum ButtonAction { restart }

class ParticleNumber {
  static int minimum = 50;
  static int low = 100;
  static int medium = 200;
  static int high = 300;
  static int maximum = 400;
}

class TicTacToeWorld extends World with HasGameReference<TicTacToeGame>{
  static final Vector2 padding = Vector2(10, 75);
  static final playArea = Vector2(
    383 - padding.x,
    759 - padding.y
  );
  static int numOfWinParticles = ParticleNumber.medium;

  static final TicTacToeBoard board = TicTacToeBoard();

  @override
  FutureOr<void> onLoad() {
    final mid = Vector2(playArea.x / 2, playArea.y / 2);

    final camera = game.camera;
    camera.viewfinder.visibleGameSize = playArea;
    camera.viewfinder.position = Vector2(
        mid.x - padding.x,
        mid.y - padding.y
    );
    camera.viewfinder.anchor = Anchor.center;

    add(board);

    board.makeBoard(mid, this);

    addButton("Restart", Vector2(board.boxes[4].position.x + TicTacToeBoard.cellSize.x / 2, board.position.y + TicTacToeBoard.cellSize.y * 3.5), ButtonAction.restart);
    addLabel("X Score: ", board.xWins, Vector2(board.boxes[0].position.x + TicTacToeBoard.cellSize.x / 2 - 80, board.position.y - TicTacToeBoard.cellSize.y));
    addLabel("O Score: ", board.oWins, Vector2(board.boxes[6].position.x + TicTacToeBoard.cellSize.x / 2 - 40, board.position.y - TicTacToeBoard.cellSize.y));

    return super.onLoad();
  }

  void addLabel(String label, Function value, Vector2 position, {fontSize=10}) {
    final textLabel = Label(
      label,
      value,
      size: Vector2(80, 40),
      position: position
    );

    add(textLabel);
  }

  void addButton(String label, Vector2 position, ButtonAction action) {
    final button = Button(
      label,
      size: Vector2(100, 50),
      position: position,
      onReleased: () {
        switch (action) {
          case ButtonAction.restart:
            restart();
            break;
        }
      },
    );
    add(button);
  }

  void restart() {
    board.restart();
  }
}