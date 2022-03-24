import 'dart:math';

import 'package:capitals_quiz/components/background.dart';
import 'package:capitals_quiz/components/capital_card.dart';
import 'package:capitals_quiz/components/controls.dart';
import 'package:capitals_quiz/components/finish_quiz_widget.dart';
import 'package:capitals_quiz/components/header.dart';
import 'package:capitals_quiz/components/progress.dart';
import 'package:capitals_quiz/quiz.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with GameMixin<GameScreen> {
  final TCardController _cardsController = TCardController();

  @override
  void initState() {
    super.initState();
    onInit();
  }

  @override
  Widget build(BuildContext context) {

    var mainColor = currentPalette?.mutedColor?.color;
    var secondColor = currentPalette?.vibrantColor?.color;
    final defaultColor =
        mainColor ?? secondColor ?? Theme.of(context).backgroundColor;
    mainColor = mainColor ?? defaultColor;
    secondColor = secondColor ?? defaultColor;

    return Scaffold(
      body: Background(
        startColor: mainColor.withOpacity(0.3),
        endColor: secondColor.withOpacity(0.3),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              if (items.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Progress(
                  color: secondColor.withOpacity(0.6),
                  progress: current / items.length,
                  duration: const Duration(seconds: 15),
                ),
              ),
              if (items.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Progress(
                  color: mainColor.withOpacity(0.4),
                  progress: max(0, score) / topScore,
                ),
              ),
              isCompleted && items.isNotEmpty
                  ? Positioned.fill(
                child: FinishQuizWidget(
                  score: score,
                  topScore: topScore,
                  onTap: reset,
                ),
              )
                  : Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(secondColor)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => {
                      Navigator.pushNamed(context, "/home"),
                    },
                  ),
                ),
              ),
              if (!isCompleted && items.isNotEmpty)
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6)
                            .copyWith(top: 6.0),
                        child: Headers(
                          title: 'Is it ${items[current].capital}?',
                          subtitle: items[current].country,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: TCard(
                          slideSpeed: 25,
                          delaySlideFor: 60,
                          controller: _cardsController,
                          cards: items
                              .map((e) => CapitalCard(key: ValueKey(e), item: e))
                              .toList(),
                          onForward: (index, info) => onGuess(
                            index,
                            info.direction == SwipDirection.Right,
                            items[current].fake != null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Controls(
                          onAnswer: (isTrue) => _cardsController.forward(
                            direction:
                            isTrue ? SwipDirection.Right : SwipDirection.Left,
                          ),
                        ),
                      ),
                    ])
            ],
          ),
        ),
      ),
    );
  }
}