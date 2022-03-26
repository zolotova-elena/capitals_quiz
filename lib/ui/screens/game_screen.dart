import 'dart:math';

import 'package:capitals_quiz/domain/background_logic.dart';
import 'package:capitals_quiz/domain/items_logic.dart';
import 'package:capitals_quiz/domain/quiz_logic.dart';
import 'package:capitals_quiz/models/color_pair.dart';
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
    onInit();
  }

  Future<void> onInit() async {
    await assets.load();
    await quiz.onStartGame();
  }

  @override
  void dispose() {
    palette.dispose();
    itemsLogic.dispose();
    quiz.dispose();
    super.dispose();
  }

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
      body: StreamBuilder<ColorPair>(
          initialData: palette.colors,
          stream: palette.stream,
          builder: (context, snapshot) {
            final colors = snapshot.requireData;
            return Background(
              startColor: colors.main.withOpacity(0.3),
              endColor: colors.second.withOpacity(0.3),
              child: SafeArea(
                bottom: false,
                child: StreamBuilder<bool>(
                  initialData: itemsLogic.state.isCompleted,
                  stream: itemsLogic.stream
                      .map((state) => state.isCompleted)
                      .distinct(),
                  builder: (context, snapshot) {
                    final isCompleted = snapshot.requireData;
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: StreamBuilder<ItemsState>(
                              initialData: itemsLogic.state,
                              stream: itemsLogic.stream,
                              builder: (context, snapshot) {
                                final progress = snapshot.requireData.progress;
                                return Progress(
                                  color: colors.second.withOpacity(0.6),
                                  progress: progress,
                                  duration: const Duration(seconds: 15),
                                );
                              }),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: StreamBuilder<QuizState>(
                            initialData: quiz.state,
                            stream: quiz.stream,
                            builder: (context, snapshot) {
                              final progress = snapshot.requireData.progress;
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Progress(
                                  color: colors.main.withOpacity(0.4),
                                  progress: progress,
                                ),
                              );
                            },
                          ),
                        ),
                        StreamBuilder<ItemsState>(
                            initialData: itemsLogic.state,
                            stream: itemsLogic.stream,
                            builder: (context, snapshot) {
                              final isCompleted =
                                  snapshot.requireData.isCompleted;
                              return isCompleted
                                  ? Positioned.fill(
                                      child: FinishQuizWidget(
                                        score: quiz.state.score,
                                        topScore: quiz.state.topScore,
                                        onTap: () => quiz.onReset(),
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              colors.second)),
                                    );
                            }),
                        if (!isCompleted)
                          LayoutBuilder(
                            builder: (
                              BuildContext context,
                              BoxConstraints constraints,
                            ) =>
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 6)
                                        .copyWith(top: 6.0),
                                    child: StreamBuilder<ItemsState>(
                                        initialData: itemsLogic.state,
                                        stream: itemsLogic.stream,
                                        builder: (context, snapshot) {
                                          final state = snapshot.requireData;
                                          if (state.isEmpty) {
                                            return const SizedBox.shrink();
                                          }
                                          return Headers(
                                            title:
                                                'Is it ${state.current.capital}?',
                                            subtitle: state.current.country,
                                          );
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: StreamBuilder<ItemsState>(
                                        initialData: itemsLogic.state,
                                        stream: itemsLogic.stream,
                                        builder: (context, snapshot) {
                                          final state = snapshot.requireData;
                                          if (state.isEmpty) {
                                            return const SizedBox.shrink();
                                          }

                                          return TCard(
                                            slideSpeed: 25,
                                            delaySlideFor: 60,
                                            controller: _cardsController,
                                            cards: state.items
                                                .map((e) => CapitalCard(
                                                    key: ValueKey(e), item: e))
                                                .toList(),
                                            onForward: (index, info) =>
                                                quiz.onGuess(
                                                    index,
                                                    info.direction ==
                                                        SwipDirection.Right),
                                          );
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Controls(
                                      onAnswer: (isTrue) =>
                                          _cardsController.forward(
                                        direction: isTrue
                                            ? SwipDirection.Right
                                            : SwipDirection.Left,
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                      ],
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
