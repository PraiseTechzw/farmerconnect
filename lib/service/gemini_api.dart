import 'dart:convert';
import 'dart:typed_data'; // Added for Uint8List
import 'package:farmerconnect/models/crop_detail.dart';
import 'package:farmerconnect/models/cropreco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late GenerativeModel model;

  // Private constructor
  GeminiService._(String apiKey) {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  // Static factory method for asynchronous initialization
  static Future<GeminiService> create() async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set in the .env file');
    }
    return GeminiService._(apiKey);
  }

  /// Method to fetch detailed information about a crop.
  Future<CropDetails> getCropDetails(String cropName, String location) async {
    try {
      final prompt =
          'Provide detailed information about the crop "$cropName" in "$location". '
          'Return the response as a JSON object with the following keys: '
          '"cropName" (string), "location" (string), "optimalConditions" (string), '
          '"seasonality" (string), "careTips" (string), "regionSpecificDetails" (string), '
          'and "description" (string, a general overview).';

      final response = await model.generateContent([Content.text(prompt)]);
      print('Generated Crop Details Raw Response: ${response.text}');

      if (response.text == null || response.text!.trim().isEmpty) {
        throw Exception('Received empty response from API for crop details.');
      }

      String cleanedJsonString = response.text!;
      if (cleanedJsonString.startsWith("```json")) {
        cleanedJsonString = cleanedJsonString.substring(7);
      }
      if (cleanedJsonString.endsWith("```")) {
        cleanedJsonString = cleanedJsonString.substring(0, cleanedJsonString.length - 3);
      }
      cleanedJsonString = cleanedJsonString.trim();

      final Map<String, dynamic> jsonResponse = jsonDecode(cleanedJsonString) as Map<String, dynamic>;

      return CropDetails(
        cropName: jsonResponse['cropName'] as String? ?? cropName,
        location: jsonResponse['location'] as String? ?? location,
        description: jsonResponse['description'] as String? ?? 'No description available.',
        season: jsonResponse['seasonality'] as String? ?? 'N/A',
        tips: jsonResponse['careTips'] as String? ?? 'N/A',
        // You might want to combine optimalConditions and regionSpecificDetails into the description
        // or handle them as separate fields in your CropDetails model if it's updated.
        // For now, let's combine them into description or a general field.
        // If CropDetails model is not updated, this example assumes they are part of description.
        // optimalConditions: jsonResponse['optimalConditions'] as String? ?? 'N/A',
        // regionSpecificDetails: jsonResponse['regionSpecificDetails'] as String? ?? 'N/A',
        imageUrl: 'https://example.com/crop_image/${jsonResponse['cropName'] ?? cropName}.png', // Placeholder
      );
    } catch (e) {
      print('Error in getCropDetails: $e');
      // Fallback or rethrow, depending on how you want to handle errors.
      // For now, rethrowing to make it visible.
      throw Exception('Error fetching or parsing crop details: $e');
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

  /// Method to identify plant disease from an image.
  Future<Map<String, dynamic>> identifyDiseaseFromImage(
      Uint8List imageBytes, String? userLocation) async {
    try {
      final locationInfo = userLocation ?? 'not specified';
      final prompt = [
        Content.multi([
          TextPart(
              "Analyze the provided image of a plant. Identify any diseases present. For each identified disease, provide: 1. Disease name, 2. Symptoms observed, 3. Recommended treatments, 4. Preventative measures. If multiple diseases are present, list them all. Also, consider the location if provided: $locationInfo. Please return the response as a JSON object with a key 'diseaseInfo' which is a list of objects, each containing 'name', 'symptoms', 'treatment', and 'prevention'."),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await model.generateContent(prompt);

      print('Generated Disease Identification Response: ${response.text}');

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Received empty response from API');
      }

      // Attempt to clean the response text if it's not valid JSON directly
      String cleanedJsonString = response.text!;
      if (cleanedJsonString.startsWith("```json")) {
        cleanedJsonString = cleanedJsonString.substring(7);
      }
      if (cleanedJsonString.endsWith("```")) {
        cleanedJsonString = cleanedJsonString.substring(0, cleanedJsonString.length - 3);
      }
      cleanedJsonString = cleanedJsonString.trim();

      final decodedResponse = jsonDecode(cleanedJsonString) as Map<String, dynamic>;
      return decodedResponse;
    } catch (e) {
      print('Error in identifyDiseaseFromImage: $e');
      // Return a structured error response
      return {
        'error': 'Failed to identify disease. Please try again.',
        'details': e.toString()
      };
    }
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

Please provide crop recommendations for this location. Return the response as a JSON array, 
where each object in the array has the following keys: "cropName" (string), 
"yield" (string, e.g., "High", "Medium", "Low", or a specific value), and "harvestDate" (string, e.g., "90 days", "Mid-October").
If any information is missing or unclear, provide default recommendations based on typical conditions for the given location and season.
''';

    final response = await model.generateContent([Content.text(prompt)]);
    print('Generated Crop Recommendations Raw Response: ${response.text}');

    if (response.text == null || response.text!.trim().isEmpty) {
      print('No recommendations provided by API. Returning default recommendations.');
      return _getDefaultRecommendations();
    }

    String cleanedJsonString = response.text!;
    if (cleanedJsonString.startsWith("```json")) {
      cleanedJsonString = cleanedJsonString.substring(7);
    }
    if (cleanedJsonString.endsWith("```")) {
      cleanedJsonString = cleanedJsonString.substring(0, cleanedJsonString.length - 3);
    }
    cleanedJsonString = cleanedJsonString.trim();
    
    final List<dynamic> jsonResponse = jsonDecode(cleanedJsonString) as List<dynamic>;
    
    if (jsonResponse.isEmpty) {
      print('Parsed JSON recommendation list is empty. Returning default recommendations.');
      return _getDefaultRecommendations();
    }

    List<CropRecommendation> recommendations = [];
    for (var item in jsonResponse) {
      final Map<String, dynamic> cropMap = item as Map<String, dynamic>;
      final cropName = cropMap['cropName'] as String?;
      if (cropName != null) {
        recommendations.add(CropRecommendation(
          cropName: cropName,
          crop_yield: cropMap['yield'] as String? ?? 'N/A',
          harvestDate: cropMap['harvestDate'] as String? ?? 'N/A',
          icon: _getCropIcon(cropName),
        ));
      }
    }
    
    if (recommendations.isEmpty) {
      print('No valid crop data parsed from JSON. Returning default recommendations.');
      return _getDefaultRecommendations();
    }

    print('Final Parsed Crop Recommendations: ${recommendations.map((r) => r.cropName).toList()}');
    return recommendations;
  } catch (e) {
    print('Error in getCropRecommendations (parsing or API error): $e');
    return _getDefaultRecommendations(); // Fallback to defaults on any error
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
