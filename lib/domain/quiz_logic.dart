import 'dart:math';

import 'package:capitals_quiz/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/api.dart';
import '../data/assets.dart';
import 'background_logic.dart';
import 'items_logic.dart';

class QuizLogic extends ChangeNotifier {
  static const _successGuess = 1;
  static const _successFake = 0;
  static const _fail = -1; // todo not used
  static const _countryLimit = 10;

  var topScore = 0;
  var score = 0;

  var isError = false;

  final Random _random;
  final Api _api;
  final Assets _assets;
  final BackgroundLogic _palette;
  final ItemsLogic _itemsLogic;

  QuizLogic(this._random, this._api, this._assets, this._palette, this._itemsLogic);

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
    _updateTopScore(0);
    _itemsLogic.reset();
  }

  Future<void> onGuess(int index, bool isTrue) async {
    final isActuallyTrue = _itemsLogic.isCurrentTrue;
    var scoreUpdate = 0;
    if (isTrue && isActuallyTrue) {
      scoreUpdate = _successGuess;
    }
    if (!isTrue && !isActuallyTrue) {
      scoreUpdate = _successFake;
    }
    if (isTrue && !isActuallyTrue || !isTrue && isActuallyTrue) {
      scoreUpdate = 0;
    }
    _updateScore(score + scoreUpdate);
    _itemsLogic.updateCurrent(index);
    await _updatePalette();
  }

  Future<void> _updatePalette() => _palette.updatePalette(
      _itemsLogic.current.image,
      _itemsLogic.next?.image,
  );

  void _updateScore(int score) => _setState(() => this.score = score);

  void _updateTopScore(int topScore) => _setState(() => this.topScore = topScore);

  void _prepareItems(List<Country> countries) {
    _itemsLogic.updateItems(countries);
    final originals = _itemsLogic.originalsLength;
    final fakes = _itemsLogic.fakeLength;
    _updateTopScore(topScore + originals + fakes);
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

  void _setState(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
