import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  

// Inside your _MapScreenState class
Future<void> _getUserLocation() async {
  var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print("User Location: ${position.latitude}, ${position.longitude}");
}



// Inside your _MapScreenState class
Future<void> _getAddressFromLocation(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    String? address = placemarks[0].street; // You can access different parts of the address like street, city, etc.
    print("User Address: $address");
  }
}


  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Example'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Initial map position
          zoom: 15.0,
        ),
      ),
    );
  }
}
