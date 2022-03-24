import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Capitals quiz',
                  style:
                      TextStyle(fontSize: 62.0, fontStyle: FontStyle.italic)),
              ElevatedButton(
                  onPressed: () => {
                        Navigator.pushNamed(context, "/game"),
                      },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150), // <-- Radius
                    ),
                  ),
                  child: const Text(
                    'Start quiz',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
