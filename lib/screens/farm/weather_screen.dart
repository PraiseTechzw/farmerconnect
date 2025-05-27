import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh weather data
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCurrentWeather(),
          const SizedBox(height: 24),
          _buildDetailedForecast(),
          const SizedBox(height: 24),
          _buildWeatherAlerts(),
          const SizedBox(height: 24),
          _buildSoilConditions(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Weather',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: ${DateTime.now().toString().substring(0, 16)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.wb_sunny,
                  size: 48,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherMetric('Temperature', '25°C', Icons.thermostat),
                _buildWeatherMetric('Humidity', '65%', Icons.water_drop),
                _buildWeatherMetric('Wind', '10 km/h', Icons.air),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.blue[700],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5-Day Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildForecastDay(
                  'Monday',
                  Icons.wb_sunny,
                  '28°C',
                  '22°C',
                  'Sunny',
                  '10%',
                ),
                const Divider(),
                _buildForecastDay(
                  'Tuesday',
                  Icons.cloud,
                  '25°C',
                  '20°C',
                  'Cloudy',
                  '30%',
                ),
                const Divider(),
                _buildForecastDay(
                  'Wednesday',
                  Icons.water_drop,
                  '22°C',
                  '18°C',
                  'Rain',
                  '80%',
                ),
                const Divider(),
                _buildForecastDay(
                  'Thursday',
                  Icons.wb_sunny,
                  '26°C',
                  '21°C',
                  'Sunny',
                  '10%',
                ),
                const Divider(),
                _buildForecastDay(
                  'Friday',
                  Icons.cloud,
                  '24°C',
                  '19°C',
                  'Cloudy',
                  '40%',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastDay(
    String day,
    IconData icon,
    String highTemp,
    String lowTemp,
    String condition,
    String rainChance,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(icon),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$highTemp / $lowTemp'),
                Text(
                  condition,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              rainChance,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Alerts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.orange[100],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Heavy Rain Expected',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Expected on Wednesday, prepare for potential flooding',
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSoilConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Soil Conditions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSoilMetric('Moisture', '65%', Colors.blue),
                const Divider(),
                _buildSoilMetric('Temperature', '22°C', Colors.orange),
                const Divider(),
                _buildSoilMetric('pH Level', '6.5', Colors.green),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSoilMetric(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
