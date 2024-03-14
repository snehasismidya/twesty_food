import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/Food_details.dart';
import 'package:food_app/pages/Product.dart';
import 'package:food_app/pages/Url.dart';
import 'package:pinput/pinput.dart';

class Search extends SearchDelegate {
  List<Food> food = [];
  Search(this.food);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close with no result.
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    if (query.isEmpty) {
      return Container(
        color: Colors.black,
        child: Center(
            child: Text(
          "Enter a search query",
          style: TextStyle(color: Colors.white),
        )),
      );
    }
    // Replace with your search results UI based on the query.
    if (query.isEmpty) {
      return Container(
        color: Colors.black,
        child: Center(
            child: Text(
          "Start typing to search",
          style: TextStyle(color: Colors.white),
        )),
      );
    }

    return Container(
      color: Colors.black,
      child: FutureBuilder<List<Food>>(
        future: _filterItems(query.trim()),
        builder: (context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final searchResults = snapshot.data;

            if (x.isNotEmpty) {
              return ListView.builder(
                itemCount: x.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      x[index].foodname,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: SizedBox(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                            imageUrl: MyUrl.fullurl + x[index].foodimage)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(x[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                  child: Text(
                "No results found",
                style: TextStyle(color: Colors.white),
              ));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  List<Food> x = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    // Replace with your search results UI based on the query.

    return Container(
      color: Colors.black,
      child: FutureBuilder<List<Food>>(
        future: _filterItems(query.trim()),
        builder: (context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final searchResults = snapshot.data;

            if (x.isNotEmpty) {
              return ListView.builder(
                itemCount: x.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      x[index].foodname,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: SizedBox(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                            imageUrl: MyUrl.fullurl + x[index].foodimage)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(x[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                  child: Text(
                "No results found",
                style: TextStyle(color: Colors.white),
              ));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  //  Future searchitem(item) async {
  //   if (item == '') {

  //   } else {

  //       x = food
  //           .where((element) => element.foodname
  //               .toLowerCase()
  //               .contains(item.toString().toLowerCase()))
  //           .toList();

  //       // searchitemfoodimg.addAll(searchitemfood1);
  //       // searchitemfoodimg.addAll(searchitemfood as Iterable<Food>);

  //       //  searchitemfood.addAll(searchitemfoodimg);

  //   }
  // }

  Future<List<Food>> _filterItems(String query) async {
    query = query.toLowerCase();
    x.clear();

    if (query.isEmpty) {
      x = List.from(food);
    } else {
      x = food
          .where((item) => item.foodname.toLowerCase().contains(query))
          .toList();
    }

    print(x);
    return x;
  }
}
