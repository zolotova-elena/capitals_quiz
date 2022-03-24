import 'dart:convert';

import 'package:capitals_quiz/models/country.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<Country>> fetchCountries() async {
    final rawResponse =
        await http.get(Uri.parse('https://restcountries.com/v2/all'));
    final response = jsonDecode(rawResponse.body);
    final capitals = (response as List<dynamic>)
        .where((e) => e['name'] != null && e['capital'] != null)
        .map((e) => Country(e['name'], e['capital']))
        .toList();
    return capitals;
  }
}
