import 'package:flutter/material.dart';
import 'package:farmerconnect/models/crop_detail.dart';
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
        elevation: 0,
        backgroundColor: Colors.green[800],
      ),
      body: FutureBuilder<CropDetails>(
        future: GeminiService().getCropDetails(crop.cropName, crop.crop_yield),
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
                    // Description
                    _buildSectionTitle('Description'),
                    _buildFormattedDescription(_sanitizeText(cropDetails.description)),
      
                    const SizedBox(height: 20),
                    
                    // Best Harvest Date
                    _buildSectionTitle('Best Harvest Date'),
                    Text(
                      crop.harvestDate,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    
                    // Season
                    _buildSectionTitle('Season'),
                    Text(
                      cropDetails.season,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    
                    // Additional Tips
                    _buildSectionTitle('Additional Tips'),
                    _buildTipsSection(_sanitizeText(cropDetails.tips)),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Sanitizes the text by removing unwanted symbols like '***'.
  String _sanitizeText(String text) {
    return text.replaceAll(RegExp(r'[\*\n]+'), ' ').trim();
  }

  /// Builds a section title with optional underline.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(thickness: 2)),
        ],
      ),
    );
  }

  /// Builds a formatted description with headings and bullet points.
  Widget _buildFormattedDescription(String description) {
    final sections = description.split(RegExp(r'\*\*\*')).where((section) => section.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
      final contentParts = section.split(RegExp(r'\n{2,}')).where((content) => content.isNotEmpty).toList();

      if (contentParts.isEmpty) {
        return const SizedBox.shrink();  // Skip empty sections
      }

      final heading = contentParts.first.trim();
      final content = contentParts.length > 1 ? contentParts.sublist(1).join("\n\n") : '';

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            _buildDescriptionContent(content),
          ],
        ),
      );
    }).toList(),
  );
}

  /// Builds the content part of the description under a heading, formatted as bullet points.
  Widget _buildDescriptionContent(String content) {
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.circle, size: 6, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(child: Text(line.trim(), style: const TextStyle(fontSize: 16))),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Builds a section with tips, formatting each tip as a bullet point.
  Widget _buildTipsSection(String tips) {
    final tipsList = tips.split(RegExp(r'[.!?]')).where((tip) => tip.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tipsList.map((tip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, size: 20, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(child: Text(tip.trim(), style: const TextStyle(fontSize: 16))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
