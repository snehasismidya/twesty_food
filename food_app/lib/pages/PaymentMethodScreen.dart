import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/Address.dart';
import 'package:food_app/pages/AddressModel.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/OrderConfirm.dart';
import 'package:food_app/pages/Url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodScreen extends StatefulWidget {
  Food food;
  int quantity;

  PaymentMethodScreen(this.food, this.quantity);

  @override
  State<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState(food, quantity);
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _type = 1;
  Food food;
  int quantity;
  var price, total;

  _PaymentMethodScreenState(this.food, this.quantity);

  void _handleRadio(Object? e) => setState(() {
        _type = e as int;
      });

  Future<void> check(String id) async {
    Map data = {'id': id};
    try {
      var res = await http.post(
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "address_verification.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.of(context).pop();

        Address add = Address(
            address_id: jsondata["address_id"],
            id: jsondata["id"],
            name: jsondata["name"],
            phoneno: jsondata["phoneno"],
            pin: jsondata["pin"],
            address: jsondata["address"],
            city: jsondata["city"],
            dist: jsondata["dist"]);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirm(
              add, // Pass the entire Address object
              food,
              total,
              quantity,
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DeliveryAddressPage(food, total, quantity),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    price = int.parse(food.foodprice) * quantity;
    total = price + 40;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateway"),
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: size.width,
                    height: 55,
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _type,
                                  onChanged: _handleRadio,
                                  activeColor: Colors.orangeAccent
                                ),
                                Text(
                                  "Cash On Delivery",
                                  style: _type == 1
                                      ? TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )
                                      : TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sub Total",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                         price.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipping Fee",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                        "40",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  Divider(
                    height: 30,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payment",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                       total.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.orangeAccent),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      String uid = pref.getString("id") ?? "";
                      check(uid);
                    },
                    child: Container(
                      height: 60,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:Colors.orangeAccent
                      ),
                      child: Center(
                        child: Text(
                          "Confirm Payment",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
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
    );
  }
}