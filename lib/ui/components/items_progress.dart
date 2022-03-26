
import 'package:capitals_quiz/domain/assemble.dart';
import 'package:capitals_quiz/ui/components/progress.dart';
import 'package:flutter/cupertino.dart';

class ItemsProgress extends StatelessWidget {
  const ItemsProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        initialData: Assemble.itemsLogic.state.progress,
        stream: Assemble.itemsLogic.stream
            .map((state) => state.progress)
            .distinct(),
        builder: (context, snapshot) {
          final progress = snapshot.requireData;
          return StreamBuilder<Color>(
              initialData: Assemble.backgroundLogic.colors.second,
              stream: Assemble.backgroundLogic.stream
                  .map((state) => state.second)
                  .distinct(),
              builder: (context, snapshot) {
                final color = snapshot.requireData;
                return Progress(
                  color: color.withOpacity(0.6),
                  progress: progress,
                  duration: const Duration(seconds: 15),
                );
              });
        });
  }
}