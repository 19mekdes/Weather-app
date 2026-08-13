import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodeUrl = 'https://geocoding-api.open-meteo.com/v1/reverse';

  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    
    final apiUrl =
      '$_baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,weathercode&timezone=auto';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      return WeatherModel.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load weather data. Status Code: ${response.statusCode}',
      );
    }
  }

  Future<String> fetchLocationName({
    required double latitude,
    required double longitude,
  }) async {
    final url =
        '$_geocodeUrl?latitude=$latitude&longitude=$longitude&count=1&language=en&format=json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final results = jsonData['results'] as List<dynamic>?;
      if (results != null && results.isNotEmpty) {
        final place = results.first as Map<String, dynamic>;
        final name = place['name'] as String?;
        final admin1 = place['admin1'] as String?;
        final country = place['country'] as String?;
        if (name != null && admin1 != null) {
          return '$name, $admin1';
        }
        if (name != null && country != null) {
          return '$name, $country';
        }
        if (name != null) {
          return name;
        }
      }
      return 'Current location';
    } else {
      throw Exception(
        'Failed to fetch location name. Status Code: ${response.statusCode}',
      );
    }
  }
}