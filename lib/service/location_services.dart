import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Get the current position
    final position = await Geolocator.getCurrentPosition();
    
    // Get address from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String locationName = '';
      
      // Build location name based on available data
      if (place.administrativeArea != null) {
        locationName = place.administrativeArea!;
      }
      if (place.subAdministrativeArea != null) {
        locationName += ', ${place.subAdministrativeArea}';
      }
      if (place.locality != null) {
        locationName += ', ${place.locality}';
      }

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'locationName': locationName.isNotEmpty ? locationName : 'Unknown Location',
      };
    }

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'locationName': 'Unknown Location',
    };
  }
}
