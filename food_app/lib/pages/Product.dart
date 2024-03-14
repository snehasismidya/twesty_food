import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/Address.dart';
import 'package:food_app/pages/CartPage.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/PaymentMethodScreen.dart';
import 'package:food_app/pages/Url.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  Food food;
  ProductDetails(this.food);

  @override
  State<ProductDetails> createState() => _ProductDetailsState(food);
}

class _ProductDetailsState extends State<ProductDetails> {

  Food food;
  _ProductDetailsState(this.food);



  int count = 1;



  Future<void> addToCart(String foodid, int quantity) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String id = pref.getString("id") ?? "";

    // Create the request body
    Map<String, String> requestBody = {
      'id': id,
      'foodid': foodid,
      'quantity': quantity.toString(),
    };

    try {
      final url = Uri.parse('${MyUrl.fullurl}addcart.php');

      final response = await http.post(url, body: requestBody);

      // Make POST request to your PHP script
      // final response = await http.post(Uri.parse(apiUrl),
      //  body: requestBody);

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = jsonDecode(response.body);

        // Handle the response data
        if (data['status'] == 'true') {
          // Product added successfully
          Fluttertoast.showToast(msg: '${data['msg']}');
          print('Food added to cart: ${data['msg']}');
        } else {
          // Failed to add product
          Fluttertoast.showToast(msg: '${data['msg']}');
          print('Failed to add food to cart: ${data['msg']}');
        }
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
 

  
  Widget _buildImage() {
    return Center(
      child: Container(
        height: 400,
        width: 350,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(0),
            child: Container(
              height: 220,
              child: CachedNetworkImage(
                imageUrl: MyUrl.fullurl + food.foodimage,
                placeholder: (context, url) => Center(
                  child: const CircularProgressIndicator(),
                ),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 247, 247),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameToDescriptionPart() {
    return Container(
      // width: double.infinity,
      width: MediaQuery.of(context).size.width,
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            food.foodname,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          Row(
            children: [
              Icon(
                Icons.currency_rupee,
                size: 17,
              ),
              Text(
                " ${food.foodprice.toString()}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontFamily: "NotoSans"),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Description",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerDescription() {
    return Container(
      // height: 170,
      // color: Colors.blue,
      child: Wrap(
        children: [
          Text(
            "${food.fooddesc}",
            style: TextStyle(
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuentityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Quantity",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
                child: Icon(Icons.remove),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPart() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            // width: double.infinity,
            child:ElevatedButton(
              onPressed: () {
                
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'Do you want to Add this product',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    onConfirmBtnTap: () async {
                      await addToCart(food.foodid, count);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>CartPage(),
                        ),
                      );
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                
              },
              child: Text(
                "Add to cart",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: Colors.orangeAccent,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            height: 60,
            // width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Buy now',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  onConfirmBtnTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>PaymentMethodScreen(food,count)),
                    );
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              child: Text(
                "Buy now",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            food.foodname,
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          backgroundColor: Colors.orange,
          elevation: 0.0,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (context) => Home(),
          //       ),
          //     );
          //   },
          // ),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.notifications_none,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {},
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                SizedBox(height: 16),
                _buildNameToDescriptionPart(),
                SizedBox(
                  height: 5,
                ),
                _buildInnerDescription(),
                SizedBox(height: 16),
                _buildQuentityPart(),
                SizedBox(height: 16),
                _buildButtonPart(),
              ],
            ),
          ),
        ));
  }
}
