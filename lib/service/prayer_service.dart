import 'dart:convert';

import 'package:todolist_app/model/prayer_time_model.dart';
import 'package:http/http.dart' as http;

class PrayerService {
  static const baseUrl = "https://api.aladhan.com/v1";

  Future<PrayerTimeModel> getPrayerTimes(String city, String country) async {
    final url = "$baseUrl/timingsByCity?city=$city&country=Indonesia&method=2";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PrayerTimeModel.fromJson(jsonData);
    } else {
      throw Exception("Gagal mengambil jadwal sholat");
    }
  }

  // Ambil List Negara
  Future<Map<String, String>> getCountries() async {
    final url = "https://countriesnow.space/api/v0.1/countries";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final resp = json.decode(response.body);

      List countries = resp["data"];

      // Convert ke Map<String, String> --> countryName : iso2
      final Map<String, String> result = {
        for (var c in countries) c["country"]: c["iso2"],
      };

      return result;
    } else {
      throw Exception("Gagal mengambil negara");
    }
  }

  // Ambil List Kota
  Future<List<String>> getCities(String countryName) async {
    final url = "https://countriesnow.space/api/v0.1/countries";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final resp = json.decode(response.body);
      List countries = resp["data"];

      // cari negara berdasarkan nama
      final country = countries.firstWhere(
        (c) => c["country"] == countryName,
        orElse: () => null,
      );

      if (country == null) return [];

      return List<String>.from(country["cities"]);
    } else {
      throw Exception("Gagal mengambil kota");
    }
  }
}
