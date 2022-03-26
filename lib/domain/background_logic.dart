import 'dart:async';

import 'package:capitals_quiz/models/color_pair.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class BackgroundState {
  static const _defaultColor = Colors.grey;

  static ColorPair _buildColors(PaletteGenerator? palette) {
    var mainColor = palette?.mutedColor?.color;
    var secondColor = palette?.vibrantColor?.color;
    final defaultColor =
        mainColor ?? secondColor ?? BackgroundState._defaultColor;
    mainColor = mainColor ?? defaultColor;
    secondColor = secondColor ?? defaultColor;
    return ColorPair(mainColor, secondColor);
  }

  final PaletteGenerator? currentPalette;
  final PaletteGenerator? nextPalette;

  ColorPair get colors => currentPalette != null
      ? _buildColors(currentPalette)
      : const ColorPair(_defaultColor, _defaultColor);

  const BackgroundState({
    this.currentPalette,
    this.nextPalette,
  });

  BackgroundState copyWith({
    PaletteGenerator? currentPalette,
    PaletteGenerator? nextPalette,
  }) =>
      BackgroundState(
        currentPalette: currentPalette ?? this.currentPalette,
        nextPalette: nextPalette ?? this.nextPalette,
      );
}

class BackgroundLogic {
  final _controller = StreamController<BackgroundState>.broadcast();
  var _state = BackgroundState();

  var state = const BackgroundState();

  Stream<ColorPair> get stream =>
      _controller.stream.map((state) => state.colors);

  ColorPair get colors => _state.colors;

  Future<void> dispose() => _controller.close();

  Future<void> updatePalette(ImageProvider current, ImageProvider? next) async {
    final _crt = _state.currentPalette == null
        ? await PaletteGenerator.fromImageProvider(current)
        : _state.nextPalette;
    final _next =
        next != null ? await PaletteGenerator.fromImageProvider(next) : null;
    _updatePalettes(_crt, _next);
  }

  void _updatePalettes(PaletteGenerator? current, PaletteGenerator? next) =>
      _setState(_state.copyWith(currentPalette: current, nextPalette: next));

  void _setState(BackgroundState state) {
    _state = state;
    _controller.add(_state);
  }
}
