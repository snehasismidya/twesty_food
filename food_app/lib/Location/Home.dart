import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_app/Location/Map.dart';
import 'package:food_app/Location/Nearby_places.dart';
import 'package:food_app/Location/NetworkUtility.dart';
import 'package:food_app/Location/Search_place_Screen.dart';
import 'package:food_app/Location/current_location.dart';
import 'package:food_app/Location/simple_map_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});
//AIzaSyDaubAoaYim8Cw4wzzPdaJOX1h36xGuEIM
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void placeAutoComplete(String query) async{
    Uri uri =
        Uri.https("maps.googleapis.com", 
        'maps/api/place/autocomplete/json',
        {
          "input":query,
          "key":'AIzaSyDaubAoaYim8Cw4wzzPdaJOX1h36xGuEIM',

        }
        );

        String? response= await NetworkUtility.fetchUrl(uri);

        if(response!=null)
        {
          //placeAutoCompleteResponse result=placeAutoCompleteResponse.placeAutoCompleteResponse(response)
        }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          'Set Delivery Location',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(251, 250, 248, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                height: 50,
                child: Form(
                  child: TextFormField(
                    onChanged: (Value){
                      placeAutoComplete(Value);
                
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.orange,
                          size: 30,
                        ),
                        hintText: 'Search your location',
                        suffixIcon: const Icon(
                          Icons.mic,
                          color: Colors.orange,
                        )),
                  ),
                ),
              ),
      
              SizedBox(
                height: 25,
              ),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 234, 230, 230),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const currentlocation();
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: const Text(
                            'Use Current Location',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapScreen()));

              }, child: Text('Map'))
              // for(int i=0;i<5;i++)
              // TextFormField(),
              
              
             
              
            ]),
          ),
        ),
      ),
    );
  }
}
