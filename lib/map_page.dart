import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng pGooglePlex = LatLng(6.835928, 80.028099);
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: errorMessage != null
          ? Center(
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            )
          : SafeArea(
              child: Builder(
                builder: (context) {
                  try {
                    return GoogleMap(
                      initialCameraPosition:
                          const CameraPosition(target: pGooglePlex, zoom: 13),
                    );
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                    });
                    return Center(
                      child: Text(
                        'Failed to load map. Error: $errorMessage',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 10, 7, 6)),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
