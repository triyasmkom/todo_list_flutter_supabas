import 'dart:convert';

import 'package:todolist_app/model/holiday_model.dart';
import 'package:http/http.dart' as http;

class CalendarService {
  static Future<List<Holiday>> fetchHolidays(String? year) async {
    year = year ?? "${DateTime.now().year}";

    final url = Uri.parse("https://api-harilibur.vercel.app/api?year=$year");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Holiday.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil hari libur");
    }
  }
}
