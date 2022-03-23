import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

import 'components/background.dart';
import 'components/capital_card.dart';
import 'components/controls.dart';
import 'components/finish_quiz_widget.dart';
import 'components/header.dart';
import 'components/progress.dart';
import 'quiz.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with GameMixin<HomePage> {
  final TCardController _cardsController = TCardController();

  @override
  void initState() {
    super.initState();
    onInit();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Progress(
                color: secondColor.withOpacity(0.6),
                progress: current / items.length,
                duration: const Duration(seconds: 15),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Progress(
                color: mainColor.withOpacity(0.4),
                progress: max(0, score) / topScore,
              ),
            ),
            isCompleted
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
            if (!isCompleted)
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12)
                        .copyWith(top: 12.0),
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
                    padding: const EdgeInsets.all(12.0),
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
    );
  }
}
