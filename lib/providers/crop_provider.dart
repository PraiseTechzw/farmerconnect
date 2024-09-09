import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropProvider with ChangeNotifier {
  final List<Crop> _crops = [
    Crop(
      name: 'Tomato',
      image: 'assets/tomato.png',
      plantingInstructions: 'Plant tomatoes in rich, well-drained soil...',
      yield: 'Approximately 10 kg per plant',
      wateringSchedule: 'Water daily during dry periods.',
    ),
    Crop(
      name: 'Corn',
      image: 'assets/corn.png',
      plantingInstructions: 'Sow corn seeds 1-2 inches deep...',
      yield: 'Up to 20 ears per plant',
      wateringSchedule: 'Ensure consistent moisture, especially during tasseling.',
    ),
    Crop(
      name: 'Potato',
      image: 'assets/potato.png',
      plantingInstructions: 'Plant seed potatoes 4 inches deep...',
      yield: 'Up to 5 kg per plant',
      wateringSchedule: 'Keep soil moist but not waterlogged.',
    ),
    // Add more crops as needed
  ];

  List<Crop> get crops => _crops;

  Crop getCropByName(String name) {
    return _crops.firstWhere((crop) => crop.name == name);
  }
}
