import 'package:flame/game.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_world.dart';

class TicTacToeGame extends FlameGame {
    TicTacToeGame() : super(world: TicTacToeWorld());
}