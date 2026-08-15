import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/colors.dart';
import '../widgets/hourly_card.dart';
import '../widgets/info_item.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? weather;
  String locationName = 'Current location';
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> loadWeather() async {
    try {
      final position = await _determinePosition();
      final data = await _weatherService.fetchWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      String name;
      if (kIsWeb) {
        final lat = position.latitude;
        final lon = position.longitude;
        if ((lat - 9.03).abs() <= 0.25 && (lon - 38.74).abs() <= 0.25) {
          name = 'Addis Abeba';
        } else {
          name = '${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)}';
        }
      } else {
        try {
          name = await _weatherService.fetchLocationName(
            latitude: position.latitude,
            longitude: position.longitude,
          );
        } catch (e) {
          name =
              '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
        }
      }

      setState(() {
        weather = data;
        locationName = name;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundBottom,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.white),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundBottom,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Location Error',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          loadWeather();
                        },
                        child: const Text('Retry'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          await Geolocator.openAppSettings();
                        },
                        child: const Text('Open Settings'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (weather == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load weather")),
      );
    }

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final horizontalPadding = width * 0.05;
    final verticalPadding = height * 0.02;
    final topBarIconSize = width * 0.07;
    final cityFontSize = width * 0.08;
    final weatherIconSize = width * 0.22;
    final temperatureFontSize = width * 0.14;
    final descriptionFontSize = width * 0.05;
    final sectionSpacing = width * 0.05;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home, color: AppColors.white),
                Icon(Icons.search, color: AppColors.grey),
                Icon(Icons.notifications_none, color: AppColors.grey),
                Icon(Icons.map_outlined, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundTop,
                AppColors.backgroundMiddle,
                AppColors.backgroundBottom,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding * 5,
            ),
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    color: AppColors.white,
                    size: topBarIconSize,
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.white,
                    size: topBarIconSize,
                  ),
                ],
              ),

              SizedBox(height: sectionSpacing),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      locationName,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: cityFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: sectionSpacing * 0.6),

                    Image.asset(
                      weather!.weatherIconAsset,
                      width: weatherIconSize,
                      height: weatherIconSize,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: sectionSpacing * 0.4),

                    Text(
                      "${weather!.temperature.toStringAsFixed(0)}°C",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: temperatureFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: sectionSpacing * 0.25),

                    Text(
                      weather!.weatherDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: descriptionFontSize,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sectionSpacing),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: width * 0.08,
                runSpacing: width * 0.05,
                children: [
                  InfoItem(
                    icon: Icons.air,
                    value: "${weather!.windSpeed.toStringAsFixed(1)} km/h",
                  ),
                  InfoItem(
                    icon: Icons.water_drop,
                    value: "${weather!.humidity.toStringAsFixed(0)}%",
                  ),
                  InfoItem(
                    icon: Icons.thermostat,
                    value:
                        "${weather!.apparentTemperature.toStringAsFixed(0)}°",
                  ),
                ],
              ),

              SizedBox(height: sectionSpacing * 1.2),

              Center(
                child: Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: sectionSpacing * 0.6),

              SizedBox(
                height: height * 0.18,
                child: Builder(
                  builder: (context) {
                    final times = weather!.hourlyTimes;
                    final temps = weather!.hourlyTemperatures;
                    final codes = weather!.hourlyWeatherCodes;
                    if (times.isEmpty || temps.isEmpty) {
                      debugPrint(
                        'Hourly API data missing — using fallback hourly values',
                      );
                      final fallbackCount = 12;
                      final generatedTimes = List<DateTime>.generate(
                        fallbackCount,
                        (i) => DateTime.now().add(Duration(hours: i)),
                      );
                      final generatedTemps = List<double>.filled(
                        fallbackCount,
                        weather!.temperature,
                      );
                      final generatedCodes = List<int>.filled(
                        fallbackCount,
                        weather!.weatherCode,
                      );

                      final now = DateTime.now();
                      int startIndex = 0;
                      const int hoursToShow = 12;
                      final itemCount = hoursToShow;

                      IconData iconForCode(int code) {
                        if (code == 0) return Icons.wb_sunny;
                        if (code == 1 || code == 2) return Icons.wb_cloudy;
                        if (code == 3) return Icons.cloud;
                        if (code == 45 || code == 48) return Icons.blur_on;
                        if (code == 51 || code == 53 || code == 55)
                          return Icons.grain;
                        if (code == 61 || code == 63 || code == 65)
                          return Icons.grain;
                        if (code == 71 || code == 73 || code == 75)
                          return Icons.ac_unit;
                        if (code == 95) return Icons.flash_on;
                        return Icons.cloud;
                      }

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemCount,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: width * 0.04),
                        itemBuilder: (context, index) {
                          final i = index;
                          final dt = generatedTimes[i];
                          final temp = generatedTemps[i];
                          final code = generatedCodes[i];

                          String label;
                          if (i == startIndex &&
                              dt.difference(now).inMinutes.abs() < 90) {
                            label = 'Now';
                          } else {
                            final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
                            final suffix = dt.hour < 12 ? 'AM' : 'PM';
                            label = '$hour $suffix';
                          }

                          return SizedBox(
                            width: width * 0.26,
                            child: HourlyCard(
                              time: label,
                              temperature: '${temp.toStringAsFixed(0)}°',
                              icon: iconForCode(code),
                            ),
                          );
                        },
                      );
                    }

                    final now = DateTime.now();
                    int startIndex = times.indexWhere((t) => !t.isBefore(now));
                    if (startIndex == -1) startIndex = 0;
                    const int hoursToShow = 12;
                    final endIndex = (startIndex + hoursToShow).clamp(
                      0,
                      times.length,
                    );
                    final itemCount = endIndex - startIndex;

                    IconData iconForCode(int code) {
                      if (code == 0) return Icons.wb_sunny;
                      if (code == 1 || code == 2) return Icons.wb_cloudy;
                      if (code == 3) return Icons.cloud;
                      if (code == 45 || code == 48) return Icons.blur_on;
                      if (code == 51 || code == 53 || code == 55)
                        return Icons.grain;
                      if (code == 61 || code == 63 || code == 65)
                        return Icons.grain;
                      if (code == 71 || code == 73 || code == 75)
                        return Icons.ac_unit;
                      if (code == 95) return Icons.flash_on;
                      return Icons.cloud;
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemCount,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: width * 0.04),
                      itemBuilder: (context, index) {
                        final i = startIndex + index;
                        final dt = times[i];
                        final temp = temps.length > i ? temps[i] : 0.0;
                        final code = codes.length > i
                            ? codes[i]
                            : weather!.weatherCode;

                        String label;
                        if (i == startIndex &&
                            dt.difference(now).inMinutes.abs() < 90) {
                          label = 'Now';
                        } else {
                          final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
                          final suffix = dt.hour < 12 ? 'AM' : 'PM';
                          label = '$hour $suffix';
                        }

                        return SizedBox(
                          width: width * 0.26,
                          child: HourlyCard(
                            time: label,
                            temperature: '${temp.toStringAsFixed(0)}°',
                            icon: iconForCode(code),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: sectionSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
