import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/Details.dart';
import 'package:food_app/pages/ForgotPassword.dart';
import 'package:food_app/pages/LoadingDialog.dart';
import 'package:food_app/pages/Url.dart';
import 'package:food_app/pages/phone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'DashBoard.dart';
import 'Splash.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  Future<void> loginStatus(String email, String password) async {
    Map data = {"email": email, "password": password};
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_login.php"),
          body: data);

      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        Details details = Details(
          id: jsondata['id'],
          email: jsondata['email'],
          username: jsondata['username'],
          phoneno: jsondata['phoneno'],
          image: jsondata['image'],
        );
        sp = await SharedPreferences.getInstance();
        sp.setString(
          'id',
          jsondata['id'],
        );
        sp.setString(
          'email',
          jsondata['email'],
        );
        sp.setString(
          'username',
          jsondata['username'],
        );
        sp.setString(
          'phoneno',
          jsondata['phoneno'],
        );
        sp.setString(
          'image',
          jsondata['image'],
        );

        
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
        // Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Dashboard(details)));
        Fluttertoast.showToast(
          msg: jsondata["msg"],
        );
      } else {
        // Navigator.pop(context);
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
                    Image.asset(
                      'assets/images/sd3.png',
                      height: 200,
                      width: 300,
                      fit: BoxFit.cover,
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
                            Navigator.pushReplacement(
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
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPhone()));
                        },
                        child: const Text(
                          'Create New Account',
                          style:
                              TextStyle(color: Color.fromARGB(255, 144, 79, 0)),
                        )),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
