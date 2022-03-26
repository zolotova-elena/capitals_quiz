import 'dart:math';

import 'package:capitals_quiz/models/country.dart';
import 'package:capitals_quiz/models/quiz_item.dart';
import 'package:flutter/material.dart';

class ItemsLogic extends ChangeNotifier {
  var currentIndex = 0;

  final items = <QuizItem>[];

  final Random _random;

  ItemsLogic(this._random);

  QuizItem get current => items[currentIndex];

  QuizItem? get next =>
      ((currentIndex + 1) < items.length) ? items[currentIndex + 1] : null;

  bool get isCompleted => currentIndex == items.length;

  bool get isCurrentTrue => items[currentIndex].fake == null;

  int get originalsLength =>
      items.where((element) => element.fake == null).length;

  int get fakeLength => items.length - originalsLength;

  double get progress => currentIndex / items.length;

  void updateCurrent(int current) => _setState(() => currentIndex = current);

  void reset() {
    updateCurrent(0);
    final countries = items.map((e) => e.original).toList();
    updateItems(countries);
  }

  void updateItems(List<Country> countries) {
    final originals = countries.sublist(0, countries.length ~/ 2);
    final fakes = countries.sublist(countries.length ~/ 2, countries.length);
    fakes.shuffle(_random);
    final list = <QuizItem>[];
    list.addAll(originals.map((e) => QuizItem(e)));
    for (var i = 0; i < fakes.length; i++) {
      list.add(QuizItem(fakes[i], fake: fakes[(i + 1) % fakes.length]));
    }
    list.shuffle(_random);
    _setState(() {
      items.clear();
      items.addAll(list);
    });
  }

  void _setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}