import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  
  Position? _currentLocation;
    late bool servicePermission = false;
    late LocationPermission permission;
    String _currentAddress = "";
    Future<Position> _getCurrentLocation() async {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
        print('Service Disable');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return await Geolocator.getCurrentPosition();
    }
  getAddressFromCoordinates()async{
    try{
      List<Placemark>placemark=await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place=placemark[0];
      setState(() {
        _currentAddress="${place.locality},${place.country}";
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: const Text('Get User Location'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Location Coordinates',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Text(
                  "Latitude=${_currentLocation?.latitude}; Longitude=${_currentLocation?.longitude}",
                  
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Location Address',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "${_currentAddress}",
               
              ),
              const SizedBox(
                height: 50.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _currentLocation = await _getCurrentLocation();
                    await getAddressFromCoordinates();
                   
                    print("${_currentLocation}");
                    print("${_currentAddress}");
                  },
                  child: const Text('Get Location'))
            ],
          ),
        ));
  }
}
