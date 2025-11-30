class PrayerTimeModel {
  final String fajr;
  final String dhuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String sunrise;

  PrayerTimeModel({
    required this.fajr,
    required this.dhuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.sunrise,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    final times = json['data']['timings'];
    return PrayerTimeModel(
      fajr: times['Fajr'],
      dhuhur: times['Dhuhr'],
      ashar: times['Asr'],
      maghrib: times['Maghrib'],
      isya: times['Isha'],
      sunrise: times['Sunrise'],
    );
  }
}
