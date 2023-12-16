import 'package:flutter/material.dart';
import 'package:test_game/TicTacToe/tic_tac_toe_app.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              color: Colors.purple,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 30))),
      home: HomePage()));
}

class GameRoute {
  String name;
  MaterialPageRoute route;
  late Widget image;

  GameRoute(this.name, this.route, imageName) {
    loadImage(imageName);
  }

  void loadImage(String name) async {
    image = Image(
        image: AssetImage('assets/images/TicTacToe icon.png'),
        fit: BoxFit.cover);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<GameRoute> routes = [
    GameRoute(
        "Tic Tac Toe",
        MaterialPageRoute(builder: (context) => const TicTacToeApp()),
        'TicTacToe icon.png')
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Games"), centerTitle: true),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          GameRoute gameRoute = routes[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(gameRoute.route);
            },
            child: DecoratedBox(
              decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.purple, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                child: GridTile(
                  footer: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.purple, width: 2),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      child: Center(
                          child: Text(gameRoute.name,
                              style: TextStyle(color: Colors.white))),
                      color: Colors.purple.withAlpha(200)),
                  child: gameRoute.image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
