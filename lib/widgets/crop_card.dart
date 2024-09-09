import 'package:flutter/material.dart';

class CropCard extends StatelessWidget {
  final String cropName;
  final String yieldInfo;
  final IconData icon;

  const CropCard({super.key, required this.cropName, required this.yieldInfo, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 150, // Square size
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green), // Icon for crop
            const SizedBox(height: 10),
            Text(
              cropName, // Crop name
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              yieldInfo, // Yield info or crop details
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
