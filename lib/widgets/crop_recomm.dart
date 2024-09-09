import 'package:farmerconnect/screens/details/crop_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:farmerconnect/models/cropreco.dart';
import 'package:farmerconnect/service/gemini_api.dart';

class CropRecommendationWidget extends StatelessWidget {
  final String temperature;
  final String weatherType;
  final String season;
  final String windSpeed;
  final String humidity;
  final String rainfall;
  final String pressure;
  final String location;

  const CropRecommendationWidget({
    super.key,
    required this.temperature,
    required this.weatherType,
    required this.season,
    required this.windSpeed,
    required this.humidity,
    required this.rainfall,
    required this.pressure, required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CropRecommendation>>(
      future: GeminiService().getCropRecommendations(
        temperature: temperature,
        weatherType: weatherType,
        season: season,
        windSpeed: windSpeed,
        humidity: humidity,
        rainfall: rainfall,
        pressure: pressure,
        location: location,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No crop recommendations available.'));
        } else {
          final recommendations = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final crop = recommendations[index];
              return _buildCropTile(context, crop);
            },
          );
        }
      },
    );
  }

  Widget _buildCropTile(BuildContext context, CropRecommendation crop) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: Icon(
          crop.icon,
          size: 40,
          color: Colors.green,
        ),
        title: Text(
          crop.cropName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            'Harvest: ${crop.harvestDate}\nSeason: $season',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 28),
        isThreeLine: true,
        onTap: () {
          // Navigate to the details screen and pass the crop data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropDetailScreen(crop: crop),
            ),
          );
        },
      ),
    );
  }
}
