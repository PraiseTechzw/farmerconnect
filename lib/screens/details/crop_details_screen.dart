import 'package:farmerconnect/models/crop_detail.dart';
import 'package:flutter/material.dart';
import 'package:farmerconnect/models/cropreco.dart';
import 'package:farmerconnect/service/gemini_api.dart';

class CropDetailScreen extends StatelessWidget {
  final CropRecommendation crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.cropName),
      ),
      body: FutureBuilder<CropDetails>(
        future: GeminiService().getCropDetails(crop.cropName, crop.crop_yield), // Fetch additional details via Gemini API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No additional details available.'));
          } else {
            final cropDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the dynamically fetched image
                    Center(
                      child: Image.network(
                        cropDetails.imageUrl, // Assuming this is the URL of the image
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback image in case of error
                          return const Icon(Icons.broken_image, size: 200);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      cropDetails.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Best Harvest Date:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      crop.harvestDate,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Season:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cropDetails.season,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional Tips:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTipsSection(cropDetails.tips),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds a section with tips, formatting each tip as a bullet point.
  Widget _buildTipsSection(String tips) {
    // Split the tips into bullet points by looking for sentence-ending punctuation (e.g., period).
    final tipsList = tips.split(RegExp(r'[.!?]')).where((tip) => tip.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tipsList.map((tip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 18)),
              Expanded(child: Text(tip.trim(), style: const TextStyle(fontSize: 16))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
