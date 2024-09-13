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
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: Colors.blueGrey[50], // Enhanced background color
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time and season
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentDay,
                      style: const TextStyle(
                        fontSize: 22,
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

            // Temperature and weather type
            Row(
              children: [
                // Weather icon based on weatherType
                Icon(
                  _getWeatherIcon(weatherType),
                  size: 80,
                  color: Colors.blueAccent, // Icon color
                ),
                const SizedBox(width: 16),
                Text(
                  '$temperature°C',
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Weather type and pressure
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weatherType,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Pressure: $pressure mb',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weather condition cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  // Build weather info card
  Widget _buildWeatherInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.2), // Enhanced card color
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
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

  // Helper function to get season icons
  Widget _getSeasonIcon(String season) {
    switch (season.toLowerCase()) {
      case 'summer':
        return const Icon(Icons.wb_sunny, color: Colors.orange, size: 40);
      case 'autumn':
        return const Icon(Icons.park, color: Colors.brown, size: 40);
      case 'winter':
        return const Icon(Icons.ac_unit, color: Colors.lightBlue, size: 40);
      case 'spring':
        return const Icon(Icons.grass, color: Colors.green, size: 40);
      default:
        return const Icon(Icons.wb_sunny, color: Colors.orange, size: 40);
    }
  }

  // Helper function to get the corresponding icon for the weather type
  IconData _getWeatherIcon(String weatherType) {
    switch (weatherType.toLowerCase()) {
      case 'rainy':
        return Icons.grain;
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'snowy':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }
}
