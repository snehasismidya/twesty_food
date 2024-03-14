import 'package:flutter/material.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class Search_Place_Screen extends StatefulWidget {
  const Search_Place_Screen({super.key});

  @override
  State<Search_Place_Screen> createState() => _Search_Place_ScreenState();
}

const kGoogleApiKey = '';
final homeScafoldKey = GlobalKey<ScaffoldState>();

class _Search_Place_ScreenState extends State<Search_Place_Screen> {
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);

  Set<Marker> markerlist = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;

  final GlobalKey<ScaffoldState> homeScafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScafoldKey,
      appBar: AppBar(title: Text('Google search Places')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markerlist,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          ElevatedButton(
              onPressed: _handlePressButton, child: Text('Search Places'))
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        //onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "IN")]);


        displayPrediction(p!,homeScafoldKey.currentState);
  }
  
  void displayPrediction(Prediction p, ScaffoldState? currentState)async {
    GoogleMapsPlaces places=GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail=await places.getDetailsByPlaceId(p.placeId!);

    final lat= detail.result.geometry!.location.lat;
    final lng= detail.result.geometry!.location.lng;

    markerlist.clear();
    markerlist.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  // void onError(PlacesAutocompleteResponse response) {
  //   homeScafoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  // }
  
  
}
