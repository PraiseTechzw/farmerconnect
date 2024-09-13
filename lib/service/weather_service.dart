import 'dart:async';  // For Timer
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  final String apiKey = 'Y4XW6SDSGYERQMFFTGH3FL34Y';  // Replace with your actual Visual Crossing API key
  final String apiUrl = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';

  Timer? _timer;  // Timer to periodically refresh weather data

  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
        '$apiUrl/$latitude,$longitude?unitGroup=metric&include=current&key=$apiKey&contentType=json'));

      if (response.statusCode == 200) {
        final weatherData = jsonDecode(response.body);
        print('Weather Data: $weatherData');
        return weatherData;
      } else {
        print('Error: Failed to fetch weather data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch weather data');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
      throw Exception('Error fetching weather data: $error');
    }
  }

  // Function to start refreshing the weather data every minute
  void startAutoRefresh(double latitude, double longitude, Function(Map<String, dynamic>) onWeatherUpdated) {
    fetchWeather(latitude, longitude).then(onWeatherUpdated);

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      print('Refreshing weather data...');
      fetchWeather(latitude, longitude).then(onWeatherUpdated);
    });
  }

  // Function to stop the auto-refresh
  void stopAutoRefresh() {
    _timer?.cancel();
    print('Stopped refreshing weather data.');
  }
}
