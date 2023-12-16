import 'package:flutter/material.dart';

class TicTacToeSettings extends StatefulWidget {
  const TicTacToeSettings({super.key});

  @override
  State<TicTacToeSettings> createState() => _TicTacToeSettingsState();
}

class _TicTacToeSettingsState extends State<TicTacToeSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
    );
  }
}
