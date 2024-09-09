import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  final String apiKey = 'Y4XW6SDSGYERQMFFTGH3FL34Y';  // Replace with your actual Visual Crossing API key
  final String apiUrl = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';

  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
        '$apiUrl/$latitude,$longitude?unitGroup=metric&include=current&key=$apiKey&contentType=json'));

      if (response.statusCode == 200) {
        // Parse the response body and print it to the console
        final weatherData = jsonDecode(response.body);
        print('Weather Data: $weatherData');  // Print fetched weather data
        return weatherData;
      } else {
        print('Error: Failed to fetch weather data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch weather data');
      }
    } catch (error) {
      // Print error message to the console
      print('Error fetching weather data: $error');
      throw Exception('Error fetching weather data: $error');
    }
  }
}
