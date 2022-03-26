import 'dart:math';

import 'package:capitals_quiz/data/api.dart';
import 'package:capitals_quiz/data/assets.dart';
import 'package:capitals_quiz/domain/quiz_logic.dart';

import 'background_logic.dart';
import 'items_logic.dart';

class Assemble {
  static final random = Random();
  static const api = Api();
  static final assets = Assets();
  static final backgroundLogic = BackgroundLogic();
  static late final itemsLogic = ItemsLogic(random);
  static late final quizLogic = QuizLogic(random, api, assets, backgroundLogic, itemsLogic);

  const Assemble._();
}