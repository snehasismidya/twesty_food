import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/OrderDetails.dart';
import 'package:food_app/pages/Url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  late SharedPreferences sp;
  List order = [];
  // var istrue;
  bool istrue = true;
  @override
  void initState() {
    getOrder().whenComplete(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  

  Future getOrder() async {
    sp = await SharedPreferences.getInstance();
    var id = sp.getString("id") ?? "";
    try {
      var url = Uri.parse('${MyUrl.fullurl}order_fetch.php?id=$id');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata != null && jsondata.containsKey('data')) {
          // Check if 'data' is a non-null list
          if (jsondata['data'] is List) {
            order.clear();
            for (int i = 0; i < jsondata['data'].length; i++) {
              // CartItem cart = CartItem(
              //     cart_id: jsondata['data'][i]['cart_id'].toString(),
              //     PId: jsondata['data'][i]['PId'].toString(),
              //     id: jsondata['data'][i]['id'].toString(),
              //     date: jsondata['data'][i]['date'].toString(),
              //     // quantity: jsondata['data'][i]['quantity'].toString(),
              //     quantity: int.parse(jsondata['data'][i]['quantity']),
              //     productname: jsondata['data'][i]['productname'].toString(),
              //     productimage: jsondata['data'][i]['productimage'].toString(),
              //     productprice: jsondata['data'][i]['productprice'].toString(),
              //     productdescription:
              //         jsondata['data'][i]['productdescription'].toString(),
              //     categoryId: jsondata['data'][i]['categoryId'].toString(),
              //     Featured: jsondata['data'][i]['Featured'].toString());
              Order ordr = Order(
                orderid: jsondata['data'][i][ 'orderid'],
                id: jsondata['data'][i]['id'],
                foodid: jsondata['data'][i]['foodid'],
                address_id: jsondata['data'][i]['address_id'],
                pick_date: jsondata['data'][i]['pick_date'],
                delivery_between: jsondata['data'][i]['delivery_between'],
                //size: jsondata['data'][i]['size'],
                payment_option: jsondata['data'][i]['payment_option'],
                quantity: jsondata['data'][i]['quantity'],
                cancel_date: jsondata['data'][i]['cancle_date'],
                confirm_date: jsondata['data'][i]['confirm_date'],
                order_status: jsondata['data'][i]['order_status'],
                foodname: jsondata['data'][i]['foodname'],
                foodimage: jsondata['data'][i]['foodimage'],
                foodprice: jsondata['data'][i]['foodprice'],
                fooddesc: jsondata['data'][i]['fooddesc'],
                categoryid: jsondata['data'][i]['categoryid'],
              featured: jsondata['data'][i]['featured'],
                name: jsondata['data'][i]['name'],
                phoneno: jsondata['data'][i]['phoneno'],
                pin: jsondata['data'][i]['pin'],
                address: jsondata['data'][i]['address'],
                //state: jsondata['data'][i]['state'],
                city: jsondata['data'][i]['city'],
                district: jsondata['data'][i]['dist'],
              );
              order.add(ordr);
            }
          } else {
            print('Error: Data is not a List');
          }
        } else {
          print('Error: No data key found or data is null');
        }
      } else {
        print('Error: ${response.statusCode}');
      }

      return order;
    } catch (e) {
      print('Error: $e');
      throw e; // Propagate the error to the FutureBuilder
    }
  }

  Future<void> check(String orderid, int index) async {
    Map data = {'orderid': orderid};
    try {
      var res = await http.post(
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "order_cancel_verification.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        if (jsondata['order_status'] == '0') {
          istrue = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetails(order[index], istrue)));
        } else {
          istrue = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetails(order[index], istrue)));
        }
      } else {
        istrue = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetails(order[index], istrue)));
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Map<String, dynamic>> orders = [
    //   {
    //     'productName': 'Product 1',
    //     'productImage': 'assets/images/shoes.jpg',
    //     'productPrice': 250,
    //   },
    //   {
    //     'productName': 'Product 2',
    //     'productImage': 'assets/images/shoes.jpg',
    //     'productPrice': 300,
    //   },
    // ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Order',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              fontFamily: "NotoSans"),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: order.isNotEmpty
          ? ListView.builder(
              itemCount: order.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.network(
                            MyUrl.fullurl + order[index].foodimage),
                        title: Text(
                          order[index].foodname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('Price: ${order[index].foodprice}'),
                        onTap: () {
                          check(order[index].orderid, index);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             OrderDetails(order[index], istrue)));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: () {
                            check(order[index].orderid, index);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             OrderDetails(order[index], istrue)));
                          },
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}