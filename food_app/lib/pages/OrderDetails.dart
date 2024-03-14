import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/Url.dart';
import 'package:http/http.dart' as http;


class OrderDetails extends StatefulWidget {
  // const OrderDetails({Key? key}) : super(key: key);
  Order order;
  bool istrue;
  OrderDetails(this.order, this.istrue);

  @override
  State<OrderDetails> createState() => _OrderDetailsState(order, istrue);
}

class _OrderDetailsState extends State<OrderDetails> {
  Order order;
  bool istrue;
  _OrderDetailsState(this.order, this.istrue);

  Future<void> check(String orderid, String id) async {
    Map data = {'orderid': orderid, 'id': id};
    try {
      var res = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "order_cancel.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == 'true') {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: jsondata['msg']);
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: jsondata['msg']);
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(istrue);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              fontFamily: "NotoSans"),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Product Details ListTile
          ListTile(
            leading: Image.network(MyUrl.fullurl + order.foodimage),
            title: Text(
              order.foodname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            //subtitle: Text(' Size: ${order.size}'),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Quantity',
            ),
            subtitle: Text(' Quantity: ${order.quantity}'),
          ),
          const Divider(),
          // Shipping Address ListTile
          ListTile(
            title: const Text('Shipping Address'),
            subtitle: Text(
                "${order.name},\n${order.phoneno},\n${order.address},\n${order.city},\n${order.district},\n${order.pin}"),
          ),
          const Divider(),

          // Pricing Details ListTile
          ListTile(
            title: const Text('Price'),
            subtitle: Text(
                'Food Price: ${int.parse(order.foodprice) * int.parse(order.quantity)}'),
          ),

          const Divider(),
          ListTile(
            title: const Text('Ordered On'),
            subtitle: Text('Date: ${order.pick_date}'),
          ),

          const Divider(),
          const ListTile(
            title: Text('Shipping Charge'),
            subtitle: Text('Shipping Charge: ${40}'),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Total Price: ${(int.parse(order.foodprice) * int.parse(order.quantity)) + 40}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          istrue == false
              ? const ListTile(
                  title: Center(
                    child: Text(
                      'Your Order is Canceled',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          const Divider(),
          // Cancel Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Visibility(
              visible: istrue,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle cancel action
                    check(order.orderid, order.id);
                    // Close the current screen
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.black),
                  child: const Text('Cancel Order'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}