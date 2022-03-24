import 'package:capitals_quiz/components/wave.dart';
import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  static const _updateDuration = Duration(milliseconds: 600);

  final double progress;
  final Color color;
  final Duration duration;

  const Progress({
    Key? key,
    required this.progress,
    required this.color,
    this.duration = const Duration(seconds: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _updateDuration,
      curve: Curves.ease,
      height: MediaQuery.of(context).size.height * progress,
      child: Wave(
        color: color,
        duration: duration,
      ),
    );
  }
}
