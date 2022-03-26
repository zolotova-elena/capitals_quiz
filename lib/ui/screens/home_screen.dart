import 'package:capitals_quiz/ui/components/settings.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Capitals quiz'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_settingsShow ? Icons.close : Icons.settings),
            tooltip: 'Show settings',
            onPressed: () => setState(() => _settingsShow = !_settingsShow),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (_settingsShow)
              Settings(
                light: widget.light,
                onToggle: widget.onToggle,
              ),
            if (!_settingsShow)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, "/game"),
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
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
