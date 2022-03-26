import 'dart:convert';

import 'package:flutter/services.dart';

class Assets {
  Map<String, List<String>>? _pictures;

  Assets();

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/pictures.json');
    final assets = jsonDecode(raw) as Map<String, dynamic>;
    _pictures = <String, List<String>>{
      for (final asset in assets.entries)
        asset.key: List<String>.from(asset.value),
    };
  }

  List<String> capitalPictures(String capital) =>
      _pictures?[capital] ?? <String>[];
}
