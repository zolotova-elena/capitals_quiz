import 'dart:math';

import 'package:capitals_quiz/domain/assemble.dart';
import 'package:capitals_quiz/domain/items_logic.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

import 'capital_card.dart';

class Cards extends StatelessWidget {
  const Cards({
    required this.cardsController,
    required this.constraints,
    Key? key,
  }) : super(key: key);

  final TCardController cardsController;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemsState>(
        initialData: Assemble.itemsLogic.state,
        stream: Assemble.itemsLogic.stream,
        builder: (context, snapshot)
    {
      final state = snapshot.requireData;
      if (state.isEmpty) {
        return const SizedBox.shrink();
      }
      return TCard(
        slideSpeed: 25,
        delaySlideFor: 60,
        size: Size.square(
          min(
            constraints.biggest.width,
            constraints.biggest.height / 2,
          ),
        ),
        controller: cardsController,
        cards: state.items
            .map((e) => CapitalCard(key: ValueKey(e), item: e))
            .toList(),
        onForward: (index, info) {
          Assemble.quizLogic.onGuess(
            index,
            info.direction == SwipDirection.Right,
          );
        },
      );
    }
    );
  }
}