import 'package:flutter/material.dart';

class FinishQuizWidget extends StatelessWidget {
  final int score;
  final int topScore;
  final VoidCallback? onTap;

  const FinishQuizWidget({
    Key? key,
    required this.score,
    required this.topScore,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your result',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'out of $topScore',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
