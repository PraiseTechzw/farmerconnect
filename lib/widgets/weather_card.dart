import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final String temperature;
  final String weatherType;
  final String season;
  final String windSpeed;
  final String humidity;
  final String rainfall;
  final String pressure;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.weatherType,
    required this.season,
    required this.windSpeed,
    required this.humidity,
    required this.rainfall,
    required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    final String currentTime = DateFormat('h:mm a').format(DateTime.now());
    final String currentDay = DateFormat('EEEE').format(DateTime.now());

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time and Season
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentDay,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      currentTime,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                _getSeasonIcon(season),
              ],
            ),
            const SizedBox(height: 20),

            // Main Temperature and Weather Type
            Row(
              children: [
                Text(
                  '$temperature°C',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather: $weatherType',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pressure: $pressure mb',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weather condition cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfoCard('Wind', '$windSpeed km/h', Icons.air),
                _buildWeatherInfoCard('Humidity', '$humidity%', Icons.opacity),
                _buildWeatherInfoCard('Rainfall', '$rainfall mm', Icons.beach_access),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build weather info cards
  Widget _buildWeatherInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get dynamic season icons
  Widget _getSeasonIcon(String season) {
    switch (season.toLowerCase()) {
      case 'summer':
        return const Icon(Icons.wb_sunny, color: Colors.yellow, size: 40);
      case 'autumn':
        return const Icon(Icons.park, color: Colors.orange, size: 40);
      case 'winter':
        return const Icon(Icons.ac_unit, color: Colors.lightBlue, size: 40);
      case 'spring':
        return const Icon(Icons.grass, color: Colors.green, size: 40);
      default:
        return const Icon(Icons.wb_sunny, color: Colors.yellow, size: 40);
    }
  }
}
