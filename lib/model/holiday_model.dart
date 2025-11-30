class Holiday {
  final DateTime date;
  final String name;

  Holiday({required this.date, required this.name});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: _parseDate(json['holiday_date']),
      name: json['holiday_name'],
    );
  }

  static DateTime _parseDate(String raw) {
    raw = raw.trim(); // buang spasi

    final parts = raw.split("-");

    final year = parts[0];
    final month = parts[1].padLeft(2, "0");
    final day = parts[2].padLeft(2, "0");

    final fixed = "$year-$month-$day";

    return DateTime.parse(fixed);
  }
}
