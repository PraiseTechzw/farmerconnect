import 'package:flutter/material.dart';
import 'package:farmer_connect/service/gemini_api.dart';
import 'package:farmer_connect/models/crop_detail.dart';
import 'package:farmer_connect/models/cropreco.dart';

class AIProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = false;
  final List<Map<String, dynamic>> _messages = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> sendMessage(String message) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Add user message
      _messages.add({
        'text': message,
        'isUser': true,
      });
      notifyListeners();

      // Get AI response
      final response = await _geminiService.chatWithAI(message);
      
      // Add AI response
      _messages.add({
        'text': response,
        'isUser': false,
      });
    } catch (e) {
      _messages.add({
        'text': 'Sorry, I encountered an error. Please try again.',
        'isUser': false,
      });
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getCropRecommendations({
    required String temperature,
    required String weatherType,
    required String season,
    required String windSpeed,
    required String humidity,
    required String rainfall,
    required String pressure,
    required String location,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prompt = '''
        Based on the following conditions, recommend suitable crops:
        Temperature: $temperature°C
        Weather Type: $weatherType
        Season: $season
        Wind Speed: $windSpeed km/h
        Humidity: $humidity%
        Rainfall: $rainfall mm
        Pressure: $pressure mb
        Location: $location

        Please provide recommendations in the following format:
        - Crop name
        - Suitability score (0-100)
        - Brief explanation
        - Expected yield
        - Harvest time
      ''';

      final response = await _geminiService.chatWithAI(prompt);
      
      // Parse the response and convert to structured data
      final recommendations = _parseCropRecommendations(response);
      return recommendations;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getCropDetails(String crop, String location) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prompt = '''
        Provide detailed information about $crop cultivation in $location:
        - Growing conditions
        - Planting season
        - Water requirements
        - Soil type
        - Common pests and diseases
        - Harvesting time
        - Expected yield
        - Market value
      ''';

      final response = await _geminiService.chatWithAI(prompt);
      
      // Parse the response and convert to structured data
      final details = _parseCropDetails(response);
      return details;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _parseCropRecommendations(String response) {
    // TODO: Implement proper parsing of the AI response
    // For now, return dummy data
    return [
      {
        'cropName': 'Rice',
        'suitabilityScore': 85,
        'explanation': 'Ideal temperature and humidity conditions',
        'expectedYield': '4-5 tons per hectare',
        'harvestTime': '120-150 days',
      },
      {
        'cropName': 'Wheat',
        'suitabilityScore': 75,
        'explanation': 'Good temperature range for wheat cultivation',
        'expectedYield': '3-4 tons per hectare',
        'harvestTime': '100-120 days',
      },
    ];
  }

  Map<String, dynamic> _parseCropDetails(String response) {
    // TODO: Implement proper parsing of the AI response
    // For now, return dummy data
    return {
      'cropName': 'Rice',
      'growingConditions': 'Warm and humid climate',
      'plantingSeason': 'Spring',
      'waterRequirements': 'High',
      'soilType': 'Clay loam',
      'pestsAndDiseases': 'Rice blast, stem borer',
      'harvestingTime': '120-150 days',
      'expectedYield': '4-5 tons per hectare',
      'marketValue': 'High demand in local market',
    };
  }
} 