import 'package:capitals_quiz/domain/assemble.dart';
import 'package:capitals_quiz/models/color_pair.dart';
import 'package:capitals_quiz/ui/components/background.dart';
import 'package:capitals_quiz/ui/components/card_headers.dart';
import 'package:capitals_quiz/ui/components/cards.dart';
import 'package:capitals_quiz/ui/components/controls.dart';
import 'package:capitals_quiz/ui/components/items_progress.dart';
import 'package:capitals_quiz/ui/components/result_or_loading.dart';
import 'package:capitals_quiz/ui/components/score_progress.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  TCardController _cardsController = TCardController();

  final backgroundLogic = Assemble.backgroundLogic;
  final itemsLogic = Assemble.itemsLogic;
  final quizLogic = Assemble.quizLogic;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  Future<void> onInit() async {
    await Assemble.assets.load();
    await quizLogic.onStartGame();
  }

  @override
  void dispose() {
    backgroundLogic.dispose();
    itemsLogic.dispose();
    quizLogic.dispose();
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
          initialData: backgroundLogic.colors,
          stream: backgroundLogic.stream,
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
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: ItemsProgress(),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: ScoreProgress(),
                        ),
                        const ResultOrLoading(),
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
                                    child: const CardHeaders()
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Cards(
                                      cardsController: _cardsController,
                                      constraints: constraints,
                                    ),
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
