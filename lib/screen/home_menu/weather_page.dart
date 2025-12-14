import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Cuaca")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            _cardWeather(
              "Hujan Sedang",
              "33",
              "29",
              "35",
              "33",
              "weather/hujan-ringan-pm.svg",
            ),

            _cardWeather(
              "Hujan Sedang",
              "33",
              "29",
              "35",
              "33",
              "weather/hujan-ringan-pm.svg",
            ),
            _cardWeather(
              "Hujan Sedang",
              "33",
              "29",
              "35",
              "33",
              "weather/hujan-ringan-pm.svg",
            ),
            _cardWeather(
              "Hujan Sedang",
              "33",
              "29",
              "35",
              "33",
              "weather/hujan-ringan-pm.svg",
            ),
            _cardWeather(
              "Hujan Sedang",
              "33",
              "29",
              "35",
              "33",
              "weather/hujan-ringan-pm.svg",
            ),
          ],
        ),
      ),
    );
  }
}

Widget _cardWeather(
  String weather,
  String temperature,
  String minTemp,
  String maxTemp,
  String humidity,
  String imageUrl,
) {
  return Container(
    padding: EdgeInsets.all(24),
    height: 450,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          weather,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$temperature °C",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        SvgPicture.asset(imageUrl, width: 120),

        const SizedBox(height: 24),

        // Detail card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoBox('Min', "$minTemp °C"),
            _infoBox('Max', "$maxTemp °C"),
            _infoBox('Humidity', "$humidity °C"),
          ],
        ),
      ],
    ),
  );
}

Widget _infoBox(String title, String value) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        Text(value, style: const TextStyle(fontSize: 18)),
      ],
    ),
  );
}
