import 'dart:async';
import 'dart:math';

import 'package:capitals_quiz/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/api.dart';
import '../data/assets.dart';
import 'background_logic.dart';
import 'items_logic.dart';

class QuizState {
  final int score;
  final int topScore;

  const QuizState(this.score, this.topScore);

  double get progress => max(0, score) / topScore;

  QuizState copyWith({
    int? score,
    int? topScore,
  }) =>
      QuizState(
        score ?? this.score,
        topScore ?? this.topScore,
      );
}

class QuizLogic extends ChangeNotifier {
  static const _success = 1;
  static const _fail = 0;
  static const _countryLimit = 10;

  var isError = false;

  final Random _random;
  final Api _api;
  final Assets _assets;
  final BackgroundLogic _palette;
  final ItemsLogic _itemsLogic;

  final _controller = StreamController<QuizState>.broadcast();
  var _state = const QuizState(0, 1);

  QuizLogic(
      this._random, this._api, this._assets, this._palette, this._itemsLogic);

  QuizState get state => _state;

  Stream<QuizState> get stream => _controller.stream;

  Future<void> dispose() => _controller.close();

  Future<void> onStartGame() async {
    isError = false;
    try {
      var countries = await _api.fetchCountries();
      countries = _countryWithImages(countries);
      countries.shuffle(_random);
      countries = countries.sublist(0, _countryLimit);
      _prepareItems(countries);
    } catch (e) {
      isError = true;
    }
    await _updatePalette();
  }

  Future<void> onReset() async {
    _updateScore(0);
    _updateTopScore(1);
    _itemsLogic.reset();
  }

  Future<void> onGuess(int index, bool isTrue) async {
    final isActuallyTrue = _itemsLogic.state.isCurrentTrue;
    var scoreUpdate = 0;
    if ((isTrue && isActuallyTrue) || (!isTrue && !isActuallyTrue)) {
      scoreUpdate = _success;
    } else {
      scoreUpdate = 0;
    }
    if (!isTrue && !isActuallyTrue) {
      scoreUpdate = _fail;
    }

    _updateScore(state.score + scoreUpdate);
    _itemsLogic.updateCurrent(index);
    if (!_itemsLogic.state.isCompleted) {
      await _updatePalette();
    }
  }

  Future<void> _updatePalette() => _palette.updatePalette(
        _itemsLogic.state.current.image,
        _itemsLogic.state.next?.image,
      );

  void _updateScore(int score) => _setState(state.copyWith(score: score));

  void _updateTopScore(int topScore) =>
      _setState(state.copyWith(topScore: topScore));

  void _prepareItems(List<Country> countries) {
    _itemsLogic.updateItems(countries);
    final originals = _itemsLogic.state.originalsLength;
    final fakes = _itemsLogic.state.fakeLength;
    _updateTopScore(originals + fakes);
  }

  List<Country> _countryWithImages(List<Country> countries) => countries
      .where((element) => element.capital.isNotEmpty)
      .map((e) {
        final imageUrls = _assets.capitalPictures(e.capital);
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

  void _setState(QuizState state) {
    _state = state;
    _controller.add(_state);
  }
}
