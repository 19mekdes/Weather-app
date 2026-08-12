import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const HourlyCard({
    super.key,
    required this.time,
    required this.temperature,
    this.icon = Icons.cloud,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}