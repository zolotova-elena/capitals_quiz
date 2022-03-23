import 'dart:math';

import 'package:capitals_quiz/models/country.dart';
import 'package:capitals_quiz/models/quiz_item.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

import 'api.dart';
import 'assets.dart';

const _successGuess = 1;
const _successFake = 0;
const _fail = -1;

const _countryLimit = 10;

final _random = Random();

mixin GameMixin<T extends StatefulWidget> on State<T> {
  var topScore = 0;
  var score = 0;
  var current = 0;

  final items = <QuizItem>[];

  PaletteGenerator? currentPalette;
  PaletteGenerator? nextPalette;

  bool get isCompleted => current == items.length;

  Future<void> onInit() async {
    await Assets.load();
    await _onSetupGame();
    await _onUpdatePalette();
    setState(() {});
  }

  Future<void> _onSetupGame() async {
    try {
      var countries = await Api.fetchCountries();
      countries = _countryWithImages(countries);
      countries.shuffle(_random);
      countries = countries.sublist(0, _countryLimit);
      _updateItems(countries);
    } catch (e) {
      // TODO handle error
      print(e);
    }
  }

  Future<void> _onUpdatePalette() async {
    currentPalette = currentPalette == null
        ? await PaletteGenerator.fromImageProvider(items[current].image)
        : nextPalette;
    nextPalette = (current + 1) < items.length
        ? await PaletteGenerator.fromImageProvider(items[current + 1].image)
        : null;
  }

  void onGuess(int index, bool isTrue, bool isActuallyTrue) async {
    var scoreUpdate = 0;
    if (isTrue && isActuallyTrue) {
      scoreUpdate = _successGuess;
    } else if (!(isTrue && isActuallyTrue)) {
      scoreUpdate = _successFake;
    } else if (isTrue && !isActuallyTrue || !isTrue && isActuallyTrue) {
      scoreUpdate = _fail;
    }
    _updateScore(score + scoreUpdate);
    _updateCurrent(index);

    await _onUpdatePalette();

    setState(() {});
  }

  void reset() {
    _updateCurrent(0);
    _updateScore(0);
    _updateTopScore(0);
    final countries = items.map((e) => e.original).toList();
    _updateItems(countries);
    setState(() {});
  }

  void _updateCurrent(int current) => this.current = current;

  void _updateScore(int score) => this.score = score;

  void _updateTopScore(int topScore) => this.topScore = topScore;

  void _updateItems(List<Country> countries) {
    final originals = countries.sublist(0, countries.length ~/ 2);
    final fakes = countries.sublist(countries.length ~/ 2, countries.length);
    _updateTopScore(countries.length);
    fakes.shuffle(_random);
    final list = <QuizItem>[];
    list.addAll(originals.map((e) => QuizItem(e)));
    for (var i = 0; i < fakes.length; i++) {
      list.add(QuizItem(fakes[i], fake: fakes[(i + 1) % fakes.length]));
    }
    list.map((i) => print(i));
    list.shuffle(_random);
    items.clear();
    items.addAll(list);
  }

  List<Country> _countryWithImages(List<Country> countries) => countries
      .where((element) => element.capital.isNotEmpty)
      .map((e) {
        final imageUrls = Assets.capitalPictures(e.capital);
        if (imageUrls.isNotEmpty) {
          final randomIndex = _random.nextInt(imageUrls.length);
          return Country(e.name, e.capital,
              imageUrls: imageUrls, index: randomIndex);
        } else {
          return Country(e.name, e.capital, imageUrls: imageUrls, index: -1);
        }
      })
      .where((element) => element.index != -1)
      .toList();
}