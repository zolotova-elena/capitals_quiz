import 'dart:async';
import 'dart:math';

import 'package:capitals_quiz/models/country.dart';
import 'package:capitals_quiz/models/quiz_item.dart';

class ItemsState {
  static const empty = ItemsState(0, []);

  final int currentIndex;
  final List<QuizItem> items;

  const ItemsState(this.currentIndex, this.items);

  QuizItem get current => items[currentIndex];

  QuizItem? get next =>
      ((currentIndex + 1) < items.length) ? items[currentIndex + 1] : null;

  bool get isCompleted => items.isNotEmpty && currentIndex == items.length;

  bool get isEmpty => items.isEmpty;

  bool get isCurrentTrue => current.fake == null;

  int get originalsLength =>
      items.where((element) => element.fake == null).length;

  int get fakeLength => items.length - originalsLength;

  double get progress => isEmpty ? 0 : currentIndex / items.length;

  ItemsState copyWith({
    int? currentIndex,
    List<QuizItem>? items,
  }) =>
      ItemsState(
        currentIndex ?? this.currentIndex,
        items ?? this.items,
      );
}

class ItemsLogic {
  final Random _random;

  final _controller = StreamController<ItemsState>.broadcast();
  var _state = ItemsState.empty;

  ItemsLogic(this._random);

  ItemsState get state => _state;

  Stream<ItemsState> get stream => _controller.stream;

  Future<void> dispose() => _controller.close();

  void updateCurrent(int current) =>
      _setState(state.copyWith(currentIndex: current));

  void reset() {
    updateCurrent(0);
    final countries = state.items.map((e) => e.original).toList();
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
    _setState(state.copyWith(items: list));
  }

  void _setState(ItemsState state) {
    _state = state;
    _controller.add(_state);
  }
}
