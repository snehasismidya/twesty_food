import 'dart:convert';
// import 'package:eshop/Check.dart';
// import 'package:eshop/loadingdialog.dart';
// import 'package:eshop/mainurl.dart';
import 'package:flutter/material.dart';
// import 'package:eshop/order_confirm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/AddressModel.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/LoadingDialog.dart';
import 'package:food_app/pages/OrderConfirm.dart';
import 'package:food_app/pages/Url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeliveryAddressPage extends StatefulWidget {
  Food food;
  int total;
  int quantity;

  DeliveryAddressPage(this.food, this.total, this.quantity);
  // DeliveryAddressPage({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressPage> createState() =>
      _DeliveryAddressPageState(food, total, quantity);
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  Food food;
  int total;
  int quantity;

  _DeliveryAddressPageState(this.food, this.total, this.quantity);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _name = TextEditingController();

  //var _phone = TextEditingController();

  var _address = TextEditingController();

  var _city = TextEditingController();

  var _district = TextEditingController();
  var _pin = TextEditingController();

  Future address(
    String id,
    String name,
    String phoneno,
    String address,
    String city,
    String dist,
    String pin,
  ) async {
    Map data = {
      "id": id,
      "name": name,
      "phoneno": phoneno,
      "address": address,
      "city": city,
      "dist": dist,
      "pin": pin,
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "address.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        Address add = Address(
          address_id: jsondata["address_id"],
          id: jsondata["id"],
          name: jsondata["name"],
          phoneno: jsondata["phoneno"],
          address: jsondata["address"],
          city: jsondata["city"],
          dist: jsondata["dist"],
          pin: jsondata["pin"],
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirm(add, food, total, quantity),
          ),
        );

        Fluttertoast.showToast(msg: jsondata["msg"]);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            // msg: "Invalid Login Credentials",
            msg: jsondata["msg"]);
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        // msg: "Invalid Login",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add delivery Address"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Full Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextFormField(
                    //   controller: _phone,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: "Mobile Number",
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your mobile number';
                    //     } else if (value.length != 10) {
                    //       return 'Mobile number must be 10 digits';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    TextFormField(
                      controller: _address,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Address",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _city,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "City",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      controller: _district,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "District",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your district';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _pin,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pin Code",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Pin code';
                        } else if (value.length != 6) {
                          return 'PIn code must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        String uid = pref.getString("id") ?? "";
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        String phoneno = sp.getString('phoneno') ?? "";

                        if (_formKey.currentState!.validate()) {
                          address(
                            uid,
                            _name.text,
                            phoneno,
                            _address.text,
                            _city.text,
                            _district.text,
                            _pin.text,
                          );
                        } else {
                          Fluttertoast.showToast(msg: 'Enter all details');
                        }
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orangeAccent,
                        ),
                        child: Center(
                          child: Text(
                            "Add Address",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
