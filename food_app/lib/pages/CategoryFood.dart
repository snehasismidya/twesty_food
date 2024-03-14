import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/Product.dart';
import 'package:http/http.dart' as http;
import 'Category_details.dart';
import 'Url.dart';

class CategoryScreen extends StatefulWidget {
  CategoryFood c;
  // const CategoryScreen({super.key});
  CategoryScreen(this.c);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState(c);
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryFood c;
  _CategoryScreenState(this.c);

  List<Food> products = [];

  Future getData(String category) async {
    final url = Uri.parse(
        '${MyUrl.fullurl}categorywise.php'); // Replace with your PHP API URL

    final response = await http.post(
      url,
      body: {
        'category': c.categoryname,
      },
    );

    if (response.statusCode == 200) {
      List <dynamic> food = json.decode(response.body);
      setState(() {
        products = food.map((foodData) {
          return Food(
              foodid: foodData["foodid"].toString(),
              foodname:foodData["foodname"].toString(),
              foodimage: foodData["foodimage"].toString(),
              foodprice: foodData["foodprice"].toString(),
              fooddesc: foodData["fooddesc"].toString(),

              );
        }).toList();
        // _isLoading = false;
      });
      return products;
    } else {
      Fluttertoast.showToast(msg: "Failed");
    }
  }

  @override
  void initState() {
    getData(c.categoryname);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double a = MediaQuery.of(context).size.height * 0.65;
    double b = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${c.categoryname}",
              style: const TextStyle(
                color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal,
                  fontFamily: "NotoSans"),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(44, 233, 37, 30),
          ),
          body: products.isNotEmpty
              ? GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: b / a,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(products[index]),
                            ));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CachedNetworkImage(
                            imageUrl: MyUrl.fullurl + products[index].foodimage,
                            // errorWidget: (context, url, error) =>
                            //     Icon(Icons.error),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            imageBuilder: (context, imageProvider) {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  // height: MediaQuery.sizeOf(context).height,
                                  // width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // color: Colors.black,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Text(
                            products[index].foodname,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        ],
                      ),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}