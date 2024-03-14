import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';


import 'package:flutter/material.dart';
import 'package:food_app/pages/CartModel.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/Product.dart';
import 'package:food_app/pages/Url.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _userCartState();
}

class _userCartState extends State<CartPage> {
  List<CartItem> cartItems = [];
    List<Food> cartData = [];

  late SharedPreferences sp;
   var incrementQuantity, decrementQuantity;
  Future<List<CartItem>> getCart() async {
    sp = await SharedPreferences.getInstance();
    var id = sp.getString("id") ?? "";
    try {
      var url = Uri.parse('${MyUrl.fullurl}cart_fetch.php?id=$id');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata != null && jsondata.containsKey('data')) {
          // Check if 'data' is a non-null list
          if (jsondata['data'] is List) {
            cartItems.clear();
            for (int i = 0; i < jsondata['data'].length; i++) {
              CartItem cart = CartItem(
                  cartid: jsondata['data'][i]['cartid'].toString(),
                  foodid: jsondata['data'][i]['foodid'].toString(),
                  id: jsondata['data'][i]['id'].toString(),
                  date: jsondata['data'][i]['date'].toString(),
                  // quantity: jsondata['data'][i]['quantity'].toString(),
                  quantity: int.parse(jsondata['data'][i]['quantity']),

                  foodname: jsondata['data'][i]['foodname'].toString(),
                  foodimage: jsondata['data'][i]['foodimage'].toString(),
                  foodprice: jsondata['data'][i]['foodprice'].toString(),
                  fooddesc:
                      jsondata['data'][i]['fooddesc'].toString(),
                  categoryid: jsondata['data'][i]['categoryid'].toString(),
                  featured: jsondata['data'][i]['featured'].toString());
                   Food food = Food(
                foodid: jsondata['data'][i]['foodid'].toString(),
                foodname: jsondata['data'][i]['foodname'],
                foodprice: jsondata['data'][i]['foodprice'],
                foodimage: jsondata['data'][i]['foodimage'],
                fooddesc: jsondata['data'][i]['fooddesc'],
              );
              cartData.add(food);

              cartItems.add(cart);
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

      return cartItems;
    } catch (e) {
      print('Error: $e');
      throw e; // Propagate the error to the FutureBuilder
    }
  }

  Future<void> deleteProductFromCart(String cartId, int index) async {
    final url = Uri.parse('${MyUrl.fullurl}cartitem_delete.php');

    try {
      final response = await http.post(
        url,
        body: {
          'cartid': cartId,
        },
      );
      // print("cart_id:$cartId");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'true') {
          setState(() {
            cartItems.removeAt(index);
          });
          print('Food deleted from cart successfully');
        } else {
          print('Failed to delete food from cart');
        }
      } else {
        print('Failed to delete food from cart. Server error.');
      }
    } catch (error) {
      print('Error deleting Food from cart: $error');
    }
  }

  void updateProductInCart(String cartId, int newQuantity, int index) async {
    final url = Uri.parse('${MyUrl.fullurl}quantity.php');

    final response = await http.post(
      url,
      body: {
        'cartid': cartId,
        'new_quantity': newQuantity.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'true') {
        setState(() {
          cartItems[index].quantity;
        });
        print(jsonResponse['msg']);
      } else {
        print(jsonResponse['msg']);
      }
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
           centerTitle: true,
          title: Text(
            "Cart Items",
            style: TextStyle(
              color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          elevation: 0.0,
          backgroundColor: Colors.orangeAccent,
        ),
        body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
               double totalPrice = 0.0;
              for (var cartItem in cartItems) {
                totalPrice +=
                    double.parse(cartItem.foodprice) * cartItem.quantity;
              }
              return Column(
                children:[ 
                  Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: (){
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetails(cartData[index])));

                        },
                        title: Text(cartItems[index].foodname),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('${int.parse(cartItems[index].foodprice)*int.parse(cartItems[index].quantity)}'),
                            Text(
                                  '${int.parse(cartItems[index].foodprice) * cartItems[index].quantity}'),
                            Row(
                              children: [
                                Text('Quantity: ${cartItems[index].quantity}'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                        incrementQuantity =
                                            cartItems[index].quantity + 1;
                                      });
                                      updateProductInCart(
                                          cartItems[index].cartid,
                                          incrementQuantity,
                                          index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                     if (cartItems[index].quantity > 1) {
                                        setState(() {
                                          decrementQuantity =
                                              cartItems[index].quantity - 1;
                                        });
                                      } else {
                                        decrementQuantity = 1;
                                      }
                                      updateProductInCart(
                                          cartItems[index].cartid,
                                          decrementQuantity,
                                          index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: CachedNetworkImage(
                          // imageUrl: cartItems[index].productimage,
                          imageUrl: MyUrl.fullurl + cartItems[index].foodimage,
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteProductFromCart(cartItems[index].cartid,index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Display total price
                  Visibility(
                    visible: cartItems.length > 0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          // color: Colors.grey.shade200,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$totalPrice',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: Text('Checkout'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              );
            }
          },
          future: getCart(),
        ),
      ),
    );
  }
}