import 'dart:async';
import 'package:flutter/material.dart';
import 'package:farmerconnect/models/cropreco.dart';
import 'package:farmerconnect/screens/details/crop_details_screen.dart';
import 'package:farmerconnect/service/gemini_api.dart';

class CropRecommendationWidget extends StatefulWidget {
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
    required this.pressure,
    required this.location,
  });

  @override
  _CropRecommendationWidgetState createState() => _CropRecommendationWidgetState();
}

class _CropRecommendationWidgetState extends State<CropRecommendationWidget> {
  late Future<List<CropRecommendation>> _cropRecommendations;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchCropRecommendations();
    // Refresh every 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      _fetchCropRecommendations();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _fetchCropRecommendations() {
    setState(() {
      _cropRecommendations = GeminiService().getCropRecommendations(
        temperature: widget.temperature,
        weatherType: widget.weatherType,
        season: widget.season,
        windSpeed: widget.windSpeed,
        humidity: widget.humidity,
        rainfall: widget.rainfall,
        pressure: widget.pressure,
        location: widget.location,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CropRecommendation>>(
      future: _cropRecommendations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonLoading();
        } else if (snapshot.hasError) {
          return _buildErrorState();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoRecommendationUI();
        } else {
          final recommendations = snapshot.data!;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final crop = recommendations[index];
                return _buildCropTile(context, crop);
              },
            ),
          );
        }
      },
    );
  }

  // Build skeleton loading UI for smoother experience
  Widget _buildSkeletonLoading() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,  // Number of skeleton items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              leading: _buildSkeletonBox(width: 40, height: 40),
              title: _buildSkeletonBox(width: double.infinity, height: 16),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildSkeletonBox(width: double.infinity, height: 12),
                  const SizedBox(height: 5),
                  _buildSkeletonBox(width: 150, height: 12),
                ],
              ),
              trailing: _buildSkeletonBox(width: 24, height: 24),
            ),
          ),
        );
      },
    );
  }

  // Helper method for skeleton loading UI
  Widget _buildSkeletonBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  // Build UI for error state with retry option
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 10),
          const Text(
            'Oops, something went wrong!',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _fetchCropRecommendations,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UI when no recommendations are available
  Widget _buildNoRecommendationUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            size: 80,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 10),
          const Text(
            'No recommendations available at the moment.',
            style: TextStyle(fontSize: 18, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _fetchCropRecommendations,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDefaultRecommendation(),
        ],
      ),
    );
  }

  // Default recommendation suggestion when no data is available
  Widget _buildDefaultRecommendation() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: const Icon(
          Icons.eco_outlined,
          size: 40,
          color: Colors.green,
        ),
        title: const Text(
          'Default Crop Suggestion',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          'Consider planting maize due to the moderate rainfall and suitable weather.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, size: 28),
        onTap: () {
          // Optionally navigate to a default crop detail
        },
      ),
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
            'Harvest: ${crop.harvestDate}\nSeason: ${widget.season}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 28),
        isThreeLine: true,
        onTap: () {
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
