class WeatherModel {
  final double temperature;
  final double humidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final double windDirection;
  final List<DateTime> hourlyTimes;
  final List<double> hourlyTemperatures;
  final List<int> hourlyWeatherCodes;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    required this.hourlyTimes,
    required this.hourlyTemperatures,
    required this.hourlyWeatherCodes,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Parse current values (supports older and newer Open-Meteo responses)
    final current = json['current'] ?? json['current_weather'] ?? {};

    // Parse hourly arrays if available
    List<DateTime> times = [];
    List<double> temps = [];
    List<int> codes = [];

    final hourly = json['hourly'] as Map<String, dynamic>?;
    if (hourly != null) {
      final rawTimes = hourly['time'] as List<dynamic>?;
      final rawTemps = hourly['temperature_2m'] as List<dynamic>?;
      final rawCodes = hourly['weathercode'] as List<dynamic>?;

      if (rawTimes != null) {
        times = rawTimes.map((t) => DateTime.parse(t as String)).toList();
      }
      if (rawTemps != null) {
        temps = rawTemps.map((t) => (t as num).toDouble()).toList();
      }
      if (rawCodes != null) {
        codes = rawCodes.map((c) => (c as num).toInt()).toList();
      }
    }

    return WeatherModel(
      temperature: (current['temperature_2m'] ?? current['temperature']) != null
          ? ((current['temperature_2m'] ?? current['temperature']) as num)
              .toDouble()
          : 0.0,
      humidity: (current['relative_humidity_2m'] ?? 0) is num
          ? ((current['relative_humidity_2m'] ?? 0) as num).toDouble()
          : 0.0,
      apparentTemperature: (current['apparent_temperature'] ?? 0) is num
          ? ((current['apparent_temperature'] ?? 0) as num).toDouble()
          : 0.0,
      precipitation: (current['precipitation'] ?? 0) is num
          ? ((current['precipitation'] ?? 0) as num).toDouble()
          : 0.0,
      weatherCode: (current['weather_code'] ?? current['weathercode'] ?? 0)
          as int,
      windSpeed: (current['wind_speed_10m'] ?? current['windspeed'] ?? 0) is num
          ? ((current['wind_speed_10m'] ?? current['windspeed'] ?? 0) as num)
              .toDouble()
          : 0.0,
      windDirection: (current['wind_direction_10m'] ?? 0) is num
          ? ((current['wind_direction_10m'] ?? 0) as num).toDouble()
          : 0.0,
      hourlyTimes: times,
      hourlyTemperatures: temps,
      hourlyWeatherCodes: codes,
    );
  }

  String get weatherDescription {
    switch (weatherCode) {
      case 0:
        return "Clear Sky";

      case 1:
      case 2:
        return "Partly Cloudy";

      case 3:
        return "Overcast";

      case 45:
      case 48:
        return "Fog";

      case 51:
      case 53:
      case 55:
        return "Drizzle";

      case 61:
      case 63:
      case 65:
        return "Rain";

      case 71:
      case 73:
      case 75:
        return "Snow";

      case 80:
      case 81:
      case 82:
        return "Rain Showers";

      case 95:
        return "Thunderstorm";

      default:
        return "Unknown";
    }
  }

  String get weatherIcon {
    switch (weatherCode) {
      case 0:
        return "☀️";

      case 1:
      case 2:
        return "⛅";

      case 3:
        return "☁️";

      case 45:
      case 48:
        return "🌫️";

      case 51:
      case 53:
      case 55:
        return "🌦️";

      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return "🌧️";

      case 71:
      case 73:
      case 75:
        return "❄️";

      case 95:
        return "⛈️";

      default:
        return "☁️";
    }
  }

  String get weatherIconAsset {
    
    switch (weatherCode) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 71:
      case 73:
      case 75:
      case 80:
      case 81:
      case 82:
      case 95:
        return 'assets/weather/partly_cloudy.png';
      default:
        return 'assets/weather/partly_cloudy.png';
    }
  }
}