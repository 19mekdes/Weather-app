import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String temperature;
  final String description;
  final String weatherIcon;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.description,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(weatherIcon, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 15),
          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
