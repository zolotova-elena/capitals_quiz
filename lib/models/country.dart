import 'package:flutter/cupertino.dart';

class Country {
  final String name;
  final String capital;
  final List<String> imageUrls;
  final int index;

  const Country(
      this.name,
      this.capital, {
        this.imageUrls = const [''],
        this.index = 0,
      }
  );

  ImageProvider get image => NetworkImage('${imageUrls[index]}?w=600');
}