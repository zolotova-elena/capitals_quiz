import 'package:capitals_quiz/domain/assemble.dart';
import 'package:capitals_quiz/models/color_pair.dart';
import 'package:capitals_quiz/ui/components/progress.dart';
import 'package:flutter/material.dart';

class ScoreProgress extends StatelessWidget {
  const ScoreProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        initialData: Assemble.quizLogic.state.progress,
        stream: Assemble.quizLogic.stream.map((state) => state.progress).distinct(),
        builder: (context, snapshot) {
          final progress = snapshot.requireData;
          return StreamBuilder<ColorPair>(
              initialData: Assemble.backgroundLogic.colors,
              stream: Assemble.backgroundLogic.stream,
              builder: (context, snapshot) {
                final colors = snapshot.requireData;
                return Progress(
                  color: colors.main.withOpacity(0.6),
                  progress: progress,
                  duration: const Duration(seconds: 15),
                );
              });
        });
  }
}