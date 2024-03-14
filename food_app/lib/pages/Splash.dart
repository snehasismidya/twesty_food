// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/Admin_Pages/AdmDashboard.dart';
import 'package:food_app/Admin_Pages/AdminDetails.dart';
import 'package:food_app/pages/DashBoard.dart';
import 'package:food_app/pages/Details.dart';
import 'package:food_app/pages/GetStarted.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN = "login";
  static const String ADMLOGIN = "admlogin";
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF800B), Color(0xFFCE1010)]),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/images/deliver.png'),
                    height: 250,
                    width: 250,
                  ),
                  Text('The whole resturant\n food at your fingertips',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                "Developed By Snehasis",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void whereToGo() async {
    var sp = await SharedPreferences.getInstance();
    var isLoggedIn = sp.getBool(KEYLOGIN);
    var isadmLoggedIn = sp.getBool(ADMLOGIN);

    String id=sp.getString('id')??"";
    String username=sp.getString('username')??"";
    String email=sp.getString('email')??"";
    
    String phoneno=sp.getString('phoneno')??"";
    String image=sp.getString('image')??"";

    Details details=Details(id:id,email: email,username: username,phoneno: phoneno,image: image);

    String admid=sp.getString('admid')??"";
    String admname=sp.getString('admname')??"";
    String admemail=sp.getString('admemail')??"";
    
    String admphone=sp.getString('admphone')??"";
    String admimage=sp.getString('admimage')??"";

    AdminDetails admin =AdminDetails(admid: admid, admname: admname, admemail: admemail, admphone: admphone, admimage: admimage);
    
    Timer(Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(details),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GetStartedPage(),
              ));
        }
      } 
      else if (isadmLoggedIn != null) {
        if (isadmLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdmDashboard(admin),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GetStartedPage(),
              ));
        }
      }
      else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GetStartedPage(),
            ));
      }
    });
  }
}
