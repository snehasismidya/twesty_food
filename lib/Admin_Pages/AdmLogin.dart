import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/Admin_Pages/AdmDashboard.dart';
import 'package:food_app/Admin_Pages/AdminDetails.dart';
import 'package:food_app/pages/ForgotPassword.dart';
import 'package:food_app/pages/LoadingDialog.dart';
import 'package:food_app/pages/Splash.dart';
import 'package:food_app/pages/Url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdmLogin extends StatefulWidget {
  const AdmLogin({super.key});

  @override
  State<AdmLogin> createState() => _AdmLoginState();
}

class _AdmLoginState extends State<AdmLogin> {
  Uri x = Uri();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  String? _validateEmail(value) {
    if (value!.isEmpty) {
      return "Can't left blank ";
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? _validatePassword(value) {
    if (value!.isEmpty) {
      return "Can't left blank ";
    }
    return null;
  }

  bool _obscureText = true;
  late SharedPreferences sp;
  Future<void> loginStatus(String admemail, String admpassword) async {
    Map data = {"admemail": admemail, "admpassword": admpassword};
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "admlogin.php"),
          body: data);

      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        AdminDetails admin = AdminDetails(
          admid: jsondata['admid'],
          admemail: jsondata['admemail'],
          admname: jsondata['admname'],
          admphone: jsondata['admphone'],
          admimage: jsondata['admimage'],
        );
        sp = await SharedPreferences.getInstance();
        sp.setString(
          'admid',
          jsondata['admid'],
        );
        sp.setString(
          'admemail',
          jsondata['admemail'],
        );
        sp.setString(
          'admname',
          jsondata['admname'],
        );
        sp.setString(
          'admphone',
          jsondata['admphone'],
        );
        sp.setString(
          'admimage',
          jsondata['admimage'],
        );

        Navigator.pop(context);
        var shared_preferences = await SharedPreferences.getInstance();
        sp.setBool(SplashScreenState.ADMLOGIN, true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdmDashboard(admin)));
        Fluttertoast.showToast(
          msg: jsondata["msg"],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata["msg"],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(186, 186, 193, 1),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/images/man.jpg',
                        height: 200,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    const SizedBox(
                        width: 250,
                        child: Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                    const SizedBox( 
                      height: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailcontroller,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          fillColor: const Color(0xAA494A59),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0x35949494))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          labelStyle: const TextStyle(color: Colors.black),
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 11, 11, 11),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: _validateEmail,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      style: const TextStyle(color: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          fillColor: const Color(0xAA494A59),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0x35949494))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          labelStyle: const TextStyle(color: Colors.black),
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 19, 19, 19),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: _validatePassword,
                      obscureText: _obscureText,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordPage()));
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 400,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginStatus(emailcontroller.text,
                                  passwordcontroller.text);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Email id and Password");
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
