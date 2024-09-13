import 'package:farmerconnect/screens/farmers_interaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farmerconnect/service/location_services.dart';
import 'package:farmerconnect/service/weather_service.dart';
import 'package:farmerconnect/widgets/weather_card.dart';
import 'package:farmerconnect/widgets/crop_recomm.dart'; // Ensure this widget can accept location

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherApiService _weatherApiService;
  late LocationService _locationService;
  Map<String, dynamic>? _weatherData;
  String? _location;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _weatherApiService = WeatherApiService();
    _locationService = LocationService();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Fetch the current location
      final position = await _locationService.getCurrentLocation();
      final weatherData = await _weatherApiService.fetchWeather(position.latitude, position.longitude);
      
      // Optionally, you might fetch location name based on coordinates
      // For simplicity, use coordinates or a
      // static location name for now if location name fetching is not implemented
      _location = '${position.latitude}, ${position.longitude}';
      
      setState(() {
        _weatherData = weatherData;
        _isLoading = false; // Hide loading indicator
      });
    } catch (error) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      print('Error fetching weather data: $error');
    }
  }

  @override
Widget build(BuildContext context) {
  final String currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green[800],
      title: const Text('FarmerConnect'),
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color:  Colors.green[800],
            ),
            child: Text(
              'Navigation',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Farmers IA'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FarmersAIScreen()),
              );
            },
          ),
        ],
      ),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDate,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : _weatherData != null
                      ? WeatherCard(
                          temperature: _weatherData!['currentConditions']['temp'].toString(),
                          weatherType: _weatherData!['currentConditions']['conditions'],
                          season: _getSeasonFromDate(),
                          windSpeed: _weatherData!['currentConditions']['windspeed'].toString(),
                          humidity: _weatherData!['currentConditions']['humidity'].toString(),
                          rainfall: _weatherData!['currentConditions']['precip']?.toString() ?? '0',
                          pressure: _weatherData!['currentConditions']['pressure'].toString(),
                        )
                      : const Text('Failed to load weather data'),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [

                 const  Text("Crop Recommendations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                // Pass weather data and location to CropRecommendationWidget
                _isLoading
                    ? const CircularProgressIndicator()
                    : _weatherData != null && _location != null
                        ? CropRecommendationWidget(
                            temperature: _weatherData!['currentConditions']['temp'].toString(),
                            weatherType: _weatherData!['currentConditions']['conditions'],
                            season: _getSeasonFromDate(),
                            windSpeed: _weatherData!['currentConditions']['windspeed'].toString(),
                            humidity: _weatherData!['currentConditions']['humidity'].toString(),
                            rainfall: _weatherData!['currentConditions']['precip']?.toString() ?? '0',
                            pressure: _weatherData!['currentConditions']['pressure'].toString(),
                            location: _location!,
                          )
                        : const Text('No crop recommendations available'),
               
            
                
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  String _getSeasonFromDate() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }
}
