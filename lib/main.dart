import 'package:capitals_quiz/screens/game_screen.dart';
import 'package:capitals_quiz/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        routes: {
          "/home": (context) => const HomeScreen(),
          "/game": (context) => const GameScreen(),
          "/error": (context) => Scaffold(
                body: Center(
                  child: Text(
                    'Something wrong!',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
        },
      );
  }
}
