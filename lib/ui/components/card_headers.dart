import 'package:capitals_quiz/domain/assemble.dart';
import 'package:capitals_quiz/domain/items_logic.dart';
import 'package:capitals_quiz/ui/components/question_header.dart';
import 'package:flutter/material.dart';

class CardHeaders extends StatelessWidget {
  const CardHeaders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemsState>(
        initialData: Assemble.itemsLogic.state,
        stream: Assemble.itemsLogic.stream,
        builder: (context, snapshot) {
          final state = snapshot.requireData;
          if (state.isEmpty) {
            return const SizedBox.shrink();
          }
          return QuestionHeader(
            title: 'Is it ${state.current.capital}?',
            subtitle: state.current.country,
          );
        });
  }
}
