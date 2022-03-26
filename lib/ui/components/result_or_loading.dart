import 'package:capitals_quiz/domain/assemble.dart';
import 'package:capitals_quiz/domain/items_logic.dart';
import 'package:capitals_quiz/models/color_pair.dart';
import 'package:capitals_quiz/ui/components/finish_quiz_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultOrLoading extends StatelessWidget {
  const ResultOrLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemsState>(
        initialData: Assemble.itemsLogic.state,
        stream: Assemble.itemsLogic.stream,
        builder: (context, snapshot) {
          final isCompleted = snapshot.requireData.isCompleted;
          return isCompleted
              ? Positioned.fill(
            child: FinishQuizWidget(
              score: Assemble.quizLogic.state.score,
              topScore: Assemble.quizLogic.state.topScore,
              onTap: () => Assemble.quizLogic.onReset(),
            ),
          )
              : Center(
            child: StreamBuilder<ColorPair>(
                initialData: Assemble.backgroundLogic.colors,
                stream: Assemble.backgroundLogic.stream,
                builder: (context, snapshot) {
                  final colors = snapshot.requireData;
                  return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(colors.second));
                }),
          );
        });
  }
}