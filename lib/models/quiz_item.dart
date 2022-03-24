import 'package:capitals_quiz/models/country.dart';
import 'package:flutter/cupertino.dart';

class QuizItem {
  final Country original;
  final Country? fake;

  const QuizItem(this.original, {this.fake});

  String get country => fake?.name ?? original.name;

  String get capital => fake?.capital ?? original.capital;

  ImageProvider get image => original.image;
}
