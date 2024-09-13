import 'dart:convert';
import 'package:farmerconnect/models/crop_detail.dart';
import 'package:farmerconnect/models/cropreco.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late GenerativeModel model;

  GeminiService() {
    const apiKey = 'AIzaSyCH6irwSysB1Osl_dnhQzh-LvwS_YHQ9Qg'; // Replace with your API key
    if (apiKey.isEmpty) {
      throw Exception('API Key is missing!');
    }
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  /// Method to fetch detailed information about a crop.
  Future<CropDetails> getCropDetails(String cropName, String location) async {
    try {
      final prompt = 'Provide detailed information about the crop $cropName in $location, '
          'including its optimal growth conditions, seasonality, care tips, '
          'and any region-specific farming details relevant to $location.';

      // Send the prompt to the Gemini model and get the response
      final response = await model.generateContent([Content.text(prompt)]);

      // Print the generated response to the console for debugging
      print('Generated Crop Details Response: ${response.text}');

      final details = response.text?.split('\n') ?? [];

      // Process response and extract relevant details
      return CropDetails(
        cropName: cropName,
        location: location,
        imageUrl: 'https://example.com/crop_image/$cropName.png', // Placeholder for crop image
        description: details.isNotEmpty ? details.join(' ') : 'No description available',
        season: 'Seasonal data for $location from API', // Modify as needed
        tips: 'Generated farming tips for $cropName in $location.',
      );
    } catch (e) {
      // Print the error to the console for debugging
      print('Error in getCropDetails: $e');
      throw Exception('Error fetching crop details: $e');
    }
  }

/// Method to handle direct chat interaction with FarmerAI.
Future<String> chatWithAI(String userInput) async {
  try {
    // Provide a more user-centered prompt to guide the AI's response
    final prompt = 'You are FarmerAI, an expert in farming. Respond to the user\'s message directly and professionally: "$userInput"';

    // Send the prompt to the AI model and get the response
    final response = await model.generateContent([Content.text(prompt)]);

    // Debug: Print the generated chat response to the console
    print('AI Chat Response: ${response.text}');

    // Return the AI's response or a fallback message if there's no response
    return response.text?.trim() ?? 'Sorry, I couldn\'t process your request. Please try again.';
  } catch (e) {
    // Handle errors gracefully and print them for debugging
    print('Error in chatWithAI: $e');
    throw Exception('Error during chat interaction: $e');
  }
}
Future<List<CropRecommendation>> getCropRecommendations({
  required String temperature,
  required String weatherType,
  required String season,
  required String windSpeed,
  required String humidity,
  required String rainfall,
  required String pressure,
  required String location,
}) async {
  try {
    final prompt = '''
Considering the weather conditions in $location:
- Temperature: $temperature°C
- Weather Type: $weatherType
- Season: $season
- Wind Speed: $windSpeed km/h
- Humidity: $humidity%
- Rainfall: $rainfall mm
- Pressure: $pressure mb

Please provide crop recommendations for this location, including:
- Crop name
- Yield
- Harvest date

If any information is missing or unclear, provide default recommendations based on typical conditions for the given location and season.
''';

    // Send the prompt to the Gemini model and get the response
    final response = await model.generateContent([Content.text(prompt)]);
    
    // Print the generated response to the console for debugging
    print('Generated Crop Recommendations Response: ${response.text}');

    if (response.text == null || response.text!.trim().isEmpty) {
      print('No recommendations provided. Returning default recommendations.');
      return _getDefaultRecommendations();
    }

    final cropData = response.text!.split('\n');
    List<CropRecommendation> recommendations = [];
    
    String? cropName;
    String? cropYield;
    String? harvestDate;

    for (var line in cropData) {
      line = line.trim();

      final cropMatch = RegExp(r'^\*\*\d+\.\s*(.*?)\s*\*\*').firstMatch(line);
      if (cropMatch != null) {
        if (cropName != null && cropYield != null && harvestDate != null) {
          recommendations.add(CropRecommendation(
            cropName: cropName,
            crop_yield: cropYield,
            harvestDate: harvestDate,
            icon: _getCropIcon(cropName),
          ));
        }
        cropName = cropMatch.group(1)?.trim();
        cropYield = null;
        harvestDate = null;
        continue;
      }

      final yieldMatch = RegExp(r'\*\*Yield:\*\*\s*(.*)').firstMatch(line);
      if (yieldMatch != null) {
        cropYield = yieldMatch.group(1)?.trim();
        continue;
      }

      final harvestDateMatch = RegExp(r'\*\*Harvest Date:\*\*\s*(.*)').firstMatch(line);
      if (harvestDateMatch != null) {
        harvestDate = harvestDateMatch.group(1)?.trim();
        continue;
      }
    }

    // Add the last crop after the loop ends
    if (cropName != null && cropYield != null && harvestDate != null) {
      recommendations.add(CropRecommendation(
        cropName: cropName,
        crop_yield: cropYield,
        harvestDate: harvestDate,
        icon: _getCropIcon(cropName),
      ));
    }

    print('Final Crop Recommendations: ${recommendations.map((r) => r.cropName).toList()}');
    
    return recommendations;
  } catch (e) {
    print('Error in getCropRecommendations: $e');
    return _getDefaultRecommendations();
  }
}


List<CropRecommendation> _getDefaultRecommendations() {
  // Provide a set of default recommendations or fallback options
  return [
    CropRecommendation(
      cropName: 'Tomato',
      crop_yield: 'High',
      harvestDate: '70 days',
      icon: _getCropIcon('Tomato'),
    ),
    CropRecommendation(
      cropName: 'Lettuce',
      crop_yield: 'Medium',
      harvestDate: '50 days',
      icon: _getCropIcon('Lettuce'),
    ),
    // Add more default recommendations as needed
  ];
}


  /// Map crop names to relevant icons.
  IconData _getCropIcon(String cropName) {
    // Map crop names to icons
    switch (cropName.toLowerCase()) {
      case 'wheat':
        return Icons.grain;
      case 'corn':
        return Icons.crop;
      case 'rice':
        return Icons.rice_bowl;
      case 'tomato':
        return Icons.local_florist;
      case 'potato':
        return Icons.landscape;
      case 'sugarcane':
        return Icons.spa;
      default:
        return Icons.eco;
    }
  }
}
