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

/// Method to handle chat interaction with the FarmerAI.
Future<String> chatWithAI(String userInput) async {
  try {
    final prompt = 'FarmerAI conversation: $userInput';

    // Send the prompt to the Gemini model and get the response
    final response = await model.generateContent([Content.text(prompt)]);

    // Print the generated chat response for debugging
    print('AI Chat Response: ${response.text}');

    // Return the AI's chat response
    return response.text ?? 'No response available';
  } catch (e) {
    // Print the error to the console for debugging
    print('Error in chatWithAI: $e');
    throw Exception('Error in chat interaction: $e');
  }
}

  /// Method to generate crop recommendations dynamically, considering location.
  Future<List<CropRecommendation>> getCropRecommendations({
    required String temperature,
    required String weatherType,
    required String season,
    required String windSpeed,
    required String humidity,
    required String rainfall,
    required String pressure,
    required String location, // New location parameter
  }) async {
    try {
      final prompt = 'Considering the weather conditions in $location, '
          'recommend crops to plant during $season with temperature $temperature°C, '
          'weather type $weatherType, wind speed $windSpeed km/h, humidity $humidity%, '
          'rainfall $rainfall mm, and pressure $pressure mb. '
          'Include crop name, yield, harvest date, and specific care tips for $location.';

      // Send the prompt to the Gemini model and get the response
      final response = await model.generateContent([Content.text(prompt)]);
      
      // Print the generated response to the console for debugging
      print('Generated Crop Recommendations Response: ${response.text}');

      final cropData = response.text?.split('\n') ?? [];
      List<CropRecommendation> recommendations = [];
      
      String? cropName;
      String? cropYield;
      String? harvestDate;
      List<String> careTipsBuffer = [];

      for (var line in cropData) {
        line = line.trim();

        // Match crop names from headings (e.g., **1. Broad Beans (Fava Beans):**)
        final cropMatch = RegExp(r'\*\*\d+\. (.*?):\*\*').firstMatch(line);
        if (cropMatch != null) {
          if (cropName != null && cropYield != null && harvestDate != null) {
            recommendations.add(CropRecommendation(
              cropName: cropName,
              crop_yield: cropYield,
              harvestDate: harvestDate,
              icon: _getCropIcon(cropName),
            ));
          }
          // Reset for new crop
          cropName = cropMatch.group(1)?.trim();
          cropYield = null;
          harvestDate = null;
          careTipsBuffer = [];
        }

        // Match crop yield (e.g., **Yield:**  2-3 kg/plant)
        final yieldMatch = RegExp(r'\*\*Yield:\*\* (.*)').firstMatch(line);
        if (yieldMatch != null) {
          cropYield = yieldMatch.group(1)?.trim();
        }

        // Match harvest date (e.g., **Harvest Date:**  60-80 days after planting)
        final harvestDateMatch = RegExp(r'\*\*Harvest Date:\*\* (.*)').firstMatch(line);
        if (harvestDateMatch != null) {
          harvestDate = harvestDateMatch.group(1)?.trim();
        }

        // Collect care tips until a new crop starts
        final careTipsMatch = RegExp(r'\*\*Care Tips:\*\*').firstMatch(line);
        if (careTipsMatch != null) {
          // Continue accumulating care tips
          careTipsBuffer.add(line.replaceFirst(careTipsMatch.group(0)!, '').trim());
          continue;
        }
        
        if (careTipsBuffer.isNotEmpty && line.isNotEmpty) {
          careTipsBuffer.add(line);
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

      // Print the final recommendations for debugging
      print('Final Crop Recommendations: ${recommendations.map((r) => r.cropName).toList()}');
      
      return recommendations;
    } catch (e) {
      // Print the error to the console for debugging
      print('Error in getCropRecommendations: $e');
      return [];
    }
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
