import 'package:capitals_quiz/components/settings.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool light;
  final VoidCallback? onToggle;

  const HomeScreen({
    Key? key,
    this.light = false,
    this.onToggle,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _settingsShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_settingsShow)
              Settings(
                light: widget.light,
                onToggle: widget.onToggle,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(_settingsShow ? Icons.close : Icons.settings),
                  onPressed: () =>
                      {setState(() => _settingsShow = !_settingsShow)},
                ),
              ),
            ),
            if (!_settingsShow)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text('Capitals quiz',
                      style: TextStyle(
                          fontSize: 62.0, fontStyle: FontStyle.italic)),
                  ElevatedButton(
                      onPressed: () => {
                            Navigator.pushNamed(context, "/game"),
                          },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 300),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(150), // <-- Radius
                        ),
                      ),
                      child: const Text(
                        'Start quiz',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      )),
                ],
              )
          ],
        ),
      ),
    );
  }
}
