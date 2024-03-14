import 'package:flutter/material.dart';
import 'package:food_app/pages/CartPage.dart';
import 'package:food_app/pages/Details.dart';
import 'package:food_app/pages/HomePage.dart';
import 'package:food_app/pages/profilePage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  Details details;
  Dashboard(this.details);

  @override
  State<Dashboard> createState() => DashboardState(details);
}

class DashboardState extends State<Dashboard> {
  Details details;
  DashboardState(this.details);

  
  List<Widget>pages=[];
  int selectedindex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages=[HomePage(details),CartPage()];
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: selectedindex>1? profilePage(details):pages[selectedindex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: GNav(
              //backgroundColor: Colors.black,
              color: Color.fromARGB(255, 16, 16, 16),
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 7,
              padding: EdgeInsets.all(10),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: 'My Cart',
                ),
                GButton(
                  icon: Icons.person_2_sharp,
                  text: 'Profile',
                ),
              ],
              selectedIndex: selectedindex,
              onTabChange: (index) {
                setState(() {
                  selectedindex = index;
                });
              }),
        ),
      ),
    );
  }
}
