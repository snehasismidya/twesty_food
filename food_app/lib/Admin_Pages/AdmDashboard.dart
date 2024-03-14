import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_app/Admin_Pages/AdminDetails.dart';
import 'package:food_app/pages/GetStarted.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdmDashboard extends StatefulWidget {
  AdminDetails admin;
  AdmDashboard(this.admin);
  @override
  State<AdmDashboard> createState() => _AdmDashboardState(admin);
}

class _AdmDashboardState extends State<AdmDashboard> {
  AdminDetails admin;
  _AdmDashboardState(this.admin);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(title: Text('Admin Page'),
centerTitle: true,backgroundColor: Colors.orangeAccent,),
drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Snehsis Midya",style: TextStyle(color: Colors.black,fontSize: 20),),
              accountEmail: Text("admin07@gmail.com",style: TextStyle(color: Colors.black),),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    "assets/images/rolls.jpg"),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/momo.jpg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
             
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("About"),
              onTap: () {},
            ),
         
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("Contact"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async{
                var sp = await SharedPreferences.getInstance();
                      sp.clear();
                Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetStartedPage()),
                        (Route<dynamic> route) => false);
              },
            ),
            
          ],
        ),
      ),

    );
    
  }
}