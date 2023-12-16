import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_game.dart';

class TicTacToeApp extends StatefulWidget {
  const TicTacToeApp({super.key});

  @override
  State<TicTacToeApp> createState() => _MyAppState();
}

class _MyAppState extends State<TicTacToeApp> {
  TicTacToeGame game = TicTacToeGame();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Title"), centerTitle: true),
      body: Center(
        child: GameWidget(game: game,)
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.blue,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        selectedLabelStyle: const TextStyle(
          color: Colors.purple
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.purple
        ),
        fixedColor: Colors.purple,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.deepPurple), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.deepPurple), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats, color: Colors.deepPurple), label: "Stats"),
        ],
      ),
    );
  }
}

