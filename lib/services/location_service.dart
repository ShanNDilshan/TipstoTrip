// location_service.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prototype/components/LocationPicker.dart';

class LocationService {
  // Handle location permissions
  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog(
          context,
          'Location services are disabled. Please enable the services',
        );
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog(context, 'Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
          context,
          'Location permissions are permanently denied',
        );
        return false;
      }

      return true;
    } catch (e) {
      _showErrorDialog(context, 'Error accessing location services: $e');
      return false;
    }
  }

  // Show location picker
  static Future<Map<String, dynamic>?> showLocationPicker(
      BuildContext context) async {
    try {
      final hasPermission = await handleLocationPermission(context);
      if (!hasPermission) return null;

      final Position position = await Geolocator.getCurrentPosition();
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPickerMap(
            initialPosition: LatLng(position.latitude, position.longitude),
          ),
        ),
      );

      return result;
    } catch (e) {
      _showErrorDialog(context, 'Failed to access location: $e');
      return null;
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
