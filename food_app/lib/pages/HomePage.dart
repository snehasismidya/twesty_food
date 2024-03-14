import 'dart:convert';
import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/CategoryFood.dart';
import 'package:food_app/pages/GetStarted.dart';
import 'package:food_app/pages/LoadingDialog.dart';
import 'package:food_app/pages/MyOrder.dart';
import 'package:food_app/pages/OrderDetails.dart';
import 'package:food_app/pages/OrderSuccess.dart';
import 'package:food_app/pages/Product.dart';
import 'package:food_app/pages/searchpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:food_app/Location/Home.dart';
import 'package:food_app/pages/Customer_Care.dart';
import 'package:food_app/pages/Details.dart';
import 'package:food_app/pages/FaqsPage.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/SettingsPage.dart';
import 'package:food_app/pages/Splash.dart';
import 'package:food_app/pages/Url.dart';
import 'package:food_app/pages/Wallet.dart';
import 'package:food_app/pages/phone.dart';
import 'package:food_app/pages/profilePage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CartPage.dart';
import 'Category_details.dart';
import 'Login.dart';

class HomePage extends StatefulWidget {
  Details details;
  HomePage(this.details);

  @override
  State<HomePage> createState() => _HomePageState(details);
}

class _HomePageState extends State<HomePage> {
  Details details;
  _HomePageState(this.details);

  List<CategoryFood> _foods = [];
  List<Food> _popularfoods = [];
  List<Food> _curry = [];
  bool issearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_foods.isEmpty) {
      getallfood();
      getcategory();
    }
    if (_curry.isEmpty) {
      curry();
    }
    if (_popularfoods.isEmpty) {
      getData();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getcategory() async {
    try {
      final response =
          await http.get(Uri.parse('${MyUrl.fullurl}category_fetch.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _foods = data.map((fooddata) {
            return CategoryFood(
              categoryid: fooddata["categoryid"].toString(),
              categoryname: fooddata["categoryname"].toString(),
              categoryimage: fooddata["categoryimage"].toString(),
            );
          }).toList();

          // _isLoading = false;
        });
      }

      return _foods;
    } catch (e) {
      print(e);
    }
  }

  Future refresh() async {
    await getallfood();
    await getcategory();
    await getData();
    await curry();
    setState(
      () {
        _foods.clear();
        getallfood();
        getcategory();
        _popularfoods.clear();
        getData();
        _curry.clear();
        curry();
        FocusScope.of(context).unfocus();
      },
    );
  }

  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('${MyUrl.fullurl}Food_Fetch 1.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _popularfoods = data.map((foodData) {
            return Food(
                foodid: foodData["foodid"],
                foodname: foodData["foodname"],
                foodimage: foodData["foodimage"],
                fooddesc: foodData["fooddesc"],
                foodprice: foodData["foodprice"]);
          }).toList();
          // _isLoading = false;
        });
      }
      return _popularfoods;
    } catch (e) {
      print(e);
    }
  }

  Future curry() async {
    try {
      final response =
          await http.get(Uri.parse('${MyUrl.fullurl}Food_Fetch_2.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _curry = data.map((foodData) {
            return Food(
                foodid: foodData["foodid"],
                foodname: foodData["foodname"],
                foodimage: foodData["foodimage"],
                fooddesc: foodData["fooddesc"],
                foodprice: foodData["foodprice"]);
          }).toList();
          // _isLoading = false;
        });
      }
      return _curry;
    } catch (e) {
      print(e);
    }
  }

  Future getallfood() async {
    try {
      final response =
          await http.get(Uri.parse('${MyUrl.fullurl}allfoodfetch.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          searchitemfood1 = data.map((foodData) {
            return Food(
                foodid: foodData["foodid"],
                foodname: foodData["foodname"],
                foodimage: foodData["foodimage"],
                fooddesc: foodData["fooddesc"],
                foodprice: foodData["foodprice"]);
          }).toList();
          // _isLoading = false;
        });
      }
      return _curry;
    } catch (e) {
      print(e);
    }
  }

  List<CategoryFood> searchitemfood = [];
  List<Food> searchitemfood1 = [];
  List<Food> searchitemfoodimg = [];

  Future getpopularData() async {
    try {
      final response =
          await http.get(Uri.parse('${MyUrl.fullurl}food_fetch_popular.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _popularfoods = data.map((fooddata) {
            return Food(
                foodname: fooddata['foodname'],
                foodimage: fooddata['foodimage'],
                fooddesc: fooddata['fooddesc'],
                foodprice: fooddata['foodprice'],
                foodid: fooddata["id"]);
          }).toList();
          // _isLoading = false;
        });
      }
      return _popularfoods;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 103, 97, 97),
            title: const Text(
              'Twesty',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const Home()));
            //       },
            //       icon: const Icon(
            //         Icons.place,
            //         color: Colors.orangeAccent,
            //         size: 40,
            //       )),
            // ]
          ),
          drawer: Drawer(
            backgroundColor: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(details)));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.gif_box),
                    title: const Text('My Profile'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => profilePage(details)));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.gif_box),
                    title: const Text('My Cart'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('My Order'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyOrder()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Favourite'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OrderSucess()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.format_quote),
                    title: const Text('FAQs'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FAQsPage()));
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.support),
                  //   title: const Text('Support'),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => CustomerCarePage()));
                  //   },
                  // ),
                  // ListTile(
                  //   leading: const Icon(Icons.settings),
                  //   title: const Text('Settings'),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SettingsPage1()));
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      var sp = await SharedPreferences.getInstance();
                      sp.clear();
                      // sp.setBool(SplashScreenState.KEYLOGIN, false);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyPhone()),
                          (Route<dynamic> route) => false);
                    },
                  )
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          onTap: () {
                            // searchitem(value.toString().trim());
                            showSearch(
                                context: context,
                                delegate: Search(searchitemfood1));
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.orange,
                                size: 30,
                              ),
                              hintText: 'Search your favourite food...',
                              suffixIcon: FloatingActionButton.extended(
                                onPressed: () {},
                                label: Text(''),
                               
                                backgroundColor: Colors.grey[200],
                                elevation: 0,
                              ))),
                    ),
                    Visibility(
                      visible: issearch,
                      child: SizedBox(
                        height: 400,
                        child: ListView.builder(
                          itemCount: searchitemfoodimg.length,
                          itemBuilder: (context, index) {
                            final img = searchitemfoodimg[index].foodimage;
                            return ListTile(
                              title: Text(searchitemfoodimg[index].foodname),
                              trailing: CachedNetworkImage(
                                imageUrl: MyUrl.fullurl + "foodimage/${img}",
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              onTap: () {
                                //print(searchitemfood[index].foodimage);
                                Fluttertoast.showToast(
                                    msg: searchitemfoodimg[index]
                                        .foodimage
                                        .toString());
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        searchitemfoodimg[index])));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _foods.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryScreen(_foods[index])));
                            },
                            child: Container(
                                width: 80,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: MyUrl.fullurl +
                                          _foods[index].categoryimage,
                                      fit: BoxFit.cover,
                                    ))),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Popular',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _popularfoods.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        _popularfoods[
                                                            index])));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(right: 20),
                                        height: 180,
                                        width: 170,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: CachedNetworkImage(
                                            imageUrl: MyUrl.fullurl +
                                                _popularfoods[index]
                                                    .foodimage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _popularfoods[index].foodname,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 15,
                                    ),
                                    Text(_popularfoods[index].foodprice,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _curry.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        _curry[index])));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(right: 20),
                                        height: 180,
                                        width: 170,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: CachedNetworkImage(
                                            imageUrl: MyUrl.fullurl +
                                                _curry[index].foodimage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _curry[index].foodname,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 15,
                                    ),
                                    Text(_curry[index].foodprice,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //  SizedBox(
                    //   height: 200,
                    //   child: Expanded(
                    //       child: ListView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: _popularfoods.length,
                    //           itemBuilder: (context, index) {
                    //             return Column(
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     InkWell(
                    //                       onTap: () {
                    //                         Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                                 builder: (context) =>
                    //                                     ProductDetails(
                    //                                         _popularfoods[
                    //                                             index])));
                    //                       },
                    //                       child: Container(
                    //                         margin:
                    //                             EdgeInsets.only(right: 20),
                    //                         height: 180,
                    //                         width: 170,
                    //                         child: ClipRRect(
                    //                           borderRadius:
                    //                               BorderRadius.circular(30),
                    //                           child: CachedNetworkImage(
                    //                             imageUrl: MyUrl.fullurl +
                    //                                 _popularfoods[index]
                    //                                     .foodimage,
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Text(
                    //                       _popularfoods[index].foodname,
                    //                       style: TextStyle(
                    //                           fontSize: 13,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                     SizedBox(
                    //                       width: 7,
                    //                     ),
                    //                     Icon(
                    //                       Icons.currency_rupee,
                    //                       size: 15,
                    //                     ),
                    //                     Text(_popularfoods[index].foodprice,
                    //                         style: TextStyle(
                    //                             fontSize: 13,
                    //                             fontWeight: FontWeight.bold)),
                    //                   ],
                    //                 ),
                    //               ],
                    //             );
                    //           })),
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Leatest',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _popularfoods.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                      _popularfoods[index])));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: MyUrl.fullurl +
                                          _popularfoods[index].foodimage,
                                      fit: BoxFit.cover,
                                      width:
                                          MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _popularfoods[index].foodname,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee,
                                              size: 15,
                                            ),
                                            Text(
                                              _popularfoods[index].foodprice,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
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
