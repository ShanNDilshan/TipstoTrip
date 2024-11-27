import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerMap extends StatefulWidget {
  final LatLng initialPosition;

  const LocationPickerMap({Key? key, required this.initialPosition})
      : super(key: key);

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String selectedAddress = '';
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialPosition;
    _addMarker(selectedLocation!);
  }

  void _addMarker(LatLng position) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
      ),
    );
  }

  Future<String> _getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: markers,
            onTap: (LatLng position) async {
              setState(() {
                selectedLocation = position;
                _addMarker(position);
              });
              selectedAddress = await _getAddress(position);
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () async {
                if (selectedLocation != null) {
                  Navigator.pop(context, {
                    'location': selectedLocation,
                    'address': selectedAddress,
                  });
                }
              },
              child: const Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
