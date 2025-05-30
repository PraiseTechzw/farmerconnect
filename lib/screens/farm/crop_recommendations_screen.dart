import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_connect/providers/ai_provider.dart';
import 'package:farmer_connect/models/cropreco.dart';
import 'package:farmer_connect/service/location_services.dart';

class CropRecommendationsScreen extends StatefulWidget {
  const CropRecommendationsScreen({Key? key}) : super(key: key);

  @override
  _CropRecommendationsScreenState createState() => _CropRecommendationsScreenState();
}

class _CropRecommendationsScreenState extends State<CropRecommendationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'temperature': TextEditingController(),
    'weatherType': TextEditingController(),
    'season': TextEditingController(),
    'windSpeed': TextEditingController(),
    'humidity': TextEditingController(),
    'rainfall': TextEditingController(),
    'pressure': TextEditingController(),
    'location': TextEditingController(),
  };

  List<CropRecommendation> _recommendations = [];
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final locationService = LocationService();
      final location = await locationService.getCurrentLocation();
      _controllers['location']!.text = location['locationName'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getRecommendations() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final aiProvider = Provider.of<AIProvider>(context, listen: false);
      final recommendations = await aiProvider.getCropRecommendations(
        temperature: _controllers['temperature']!.text,
        weatherType: _controllers['weatherType']!.text,
        season: _controllers['season']!.text,
        windSpeed: _controllers['windSpeed']!.text,
        humidity: _controllers['humidity']!.text,
        rainfall: _controllers['rainfall']!.text,
        pressure: _controllers['pressure']!.text,
        location: _controllers['location']!.text,
      );

      setState(() {
        _recommendations = recommendations.map((map) => CropRecommendation(
          cropName: map['cropName'] as String,
          crop_yield: map['expectedYield'] as String,
          harvestDate: map['harvestTime'] as String,
          icon: _getCropIcon(map['cropName'] as String),
        )).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  IconData _getCropIcon(String cropName) {
    final cropIcons = {
      'Rice': Icons.grass,
      'Wheat': Icons.grain,
      'Corn': Icons.eco,
      'Soybeans': Icons.spa,
      'Cotton': Icons.filter_drama,
    };
    return cropIcons[cropName] ?? Icons.agriculture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Crop Recommendations'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllers['temperature'],
                    decoration: const InputDecoration(
                      labelText: 'Temperature (°C)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter temperature' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllers['weatherType'],
                    decoration: const InputDecoration(
                      labelText: 'Weather Type',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter weather type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllers['season'],
                    decoration: const InputDecoration(
                      labelText: 'Season',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter season' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllers['windSpeed'],
                    decoration: const InputDecoration(
                      labelText: 'Wind Speed (km/h)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter wind speed' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllers['humidity'],
                    decoration: const InputDecoration(
                      labelText: 'Humidity (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter humidity' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllers['rainfall'],
                    decoration: const InputDecoration(
                      labelText: 'Rainfall (mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter rainfall' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllers['pressure'],
                    decoration: const InputDecoration(
                      labelText: 'Pressure (mb)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter pressure' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controllers['location'],
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                            hintText: 'e.g., Mashonaland West, Zimbabwe',
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Please enter location' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                        icon: _isLoadingLocation
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        tooltip: 'Get Current Location',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _getRecommendations,
                    child: const Text('Get Recommendations'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Consumer<AIProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_recommendations.isNotEmpty) ...[
                      const Text(
                        'Recommended Crops:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._recommendations.map((crop) => Card(
                            child: ListTile(
                              leading: Icon(crop.icon),
                              title: Text(crop.cropName),
                              subtitle: Text(
                                  'Yield: ${crop.crop_yield}\nHarvest: ${crop.harvestDate}'),
                            ),
                          )),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 