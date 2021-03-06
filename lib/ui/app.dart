import 'package:capitals_quiz/ui/screens/game_screen.dart';
import 'package:capitals_quiz/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _light = true;

  void onToggle() => setState(() => _light = !_light);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capitals quiz',
      theme: _light ? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(light: _light, onToggle: onToggle),
      routes: {
        "/home": (context) => HomeScreen(light: _light, onToggle: onToggle),
        "/game": (context) => const GameScreen(),

        // todo not used
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
