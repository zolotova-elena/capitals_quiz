import 'dart:math';

import 'package:capitals_quiz/domain/background_logic.dart';
import 'package:capitals_quiz/domain/items_logic.dart';
import 'package:capitals_quiz/domain/quiz_logic.dart';
import 'package:capitals_quiz/models/color_pair.dart';
import 'package:capitals_quiz/models/quiz_item.dart';
import 'package:capitals_quiz/ui/components/background.dart';
import 'package:capitals_quiz/ui/components/capital_card.dart';
import 'package:capitals_quiz/ui/components/controls.dart';
import 'package:capitals_quiz/ui/components/finish_quiz_widget.dart';
import 'package:capitals_quiz/ui/components/header.dart';
import 'package:capitals_quiz/ui/components/progress.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

import '../../data/api.dart';
import '../../data/assets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TCardController _cardsController = TCardController();
  final BackgroundLogic palette = BackgroundLogic();
  final Random random = Random();
  final assets = Assets();
  late final ItemsLogic itemsLogic = ItemsLogic(random);
  late final QuizLogic quiz = QuizLogic(
    Random(),
    const Api(),
    assets,
    palette,
    itemsLogic,
  );

  @override
  void initState() {
    super.initState();
    quiz.addListener(_update);
    onInit();
  }

  Future<void> onInit() async {
    await assets.load();
    await quiz.onStartGame();
  }

  @override
  void dispose() {
    quiz.removeListener(_update);
    super.dispose();
  }

  List<QuizItem> get items => itemsLogic.items;

  int get currentIndex => itemsLogic.currentIndex;

  bool get isCompleted => itemsLogic.isCompleted;

  ColorPair get colors => palette.colors;

  int get score => quiz.score;

  int get topScore => quiz.topScore;

  @override
  Widget build(BuildContext context) {
    // todo remove conditions and create new widgets
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pushNamed(context, "/home"),
          },
        ),
      ),
      body: Background(
        startColor: colors.main.withOpacity(0.3),
        endColor: colors.second.withOpacity(0.3),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              if (items.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Progress(
                    color: colors.second.withOpacity(0.6),
                    progress: itemsLogic.progress,
                    duration: const Duration(seconds: 15),
                  ),
                ),
              if (items.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Progress(
                    color: colors.main.withOpacity(0.4),
                    progress: max(0, score) / topScore,
                  ),
                ),
              isCompleted && items.isNotEmpty
                  ? Positioned.fill(
                      child: FinishQuizWidget(
                        score: score,
                        topScore: topScore,
                        onTap: () => quiz.onReset(),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(colors.second)),
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
                          title: 'Is it ${items[currentIndex].capital}?',
                          subtitle: items[currentIndex].country,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: TCard(
                          slideSpeed: 25,
                          delaySlideFor: 60,
                          controller: _cardsController,
                          cards: items
                              .map(
                                  (e) => CapitalCard(key: ValueKey(e), item: e))
                              .toList(),
                          onForward: (index, info) => quiz.onGuess(
                              index, info.direction == SwipDirection.Right),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Controls(
                          onAnswer: (isTrue) => _cardsController.forward(
                            direction: isTrue
                                ? SwipDirection.Right
                                : SwipDirection.Left,
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

  void _update() => setState(() {});
}