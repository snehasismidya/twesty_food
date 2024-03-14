import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class currentlocation extends StatefulWidget {
  const currentlocation({super.key});

  @override
  State<currentlocation> createState() => _currentlocationState();
}

class _currentlocationState extends State<currentlocation> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  Future<String?> getAddress(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    return placemarks[0].name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User current location'),
//         Text(
//   'Current Address: ${await getAddress(currentLocation)}',
// ),



        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Position position = await _determinePostion(Permission.location);
            googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14)));

            markers.clear();
            markers.add(Marker(
                markerId: MarkerId('CurrentLocation'),
                position: LatLng(position.latitude, position.longitude)));

            setState(() {});
          },
          label: Text('Current Location'),
          icon: Icon(Icons.location_history)),
    );
  }

  Future<Position> _determinePostion(Permission permission) async {
    // bool serviceEnabled;
    LocationPermission gpermission;

   
   final status = await permission.request();
    if (status.isGranted) {

  gpermission = await Geolocator.checkPermission();
    if (gpermission == LocationPermission.denied) {
      gpermission = await Geolocator.requestPermission();

        Position position = await Geolocator.getCurrentPosition();

    return position;

      }
    //  return Future.error('Location Service are granted');
    } else {
     ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission is not Granted")));
          return Future.error('Location permission are parmanently denied');
    }

    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location Service are disable');
    // }
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();

    //   if (permission == LocationPermission.denied) {
    //     return Future.error('Location Permission denied');
    //   }
    // }
    // if (permission == LocationPermission.deniedForever) {
    //   return Future.error('Location permission are parmanently denied');
    // }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
