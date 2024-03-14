import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:food_app/Location/Home.dart';
// import 'package:food_app/pages/DashBoard.dart';
// import 'package:food_app/pages/Details.dart';
import 'package:food_app/pages/LoadingDialog.dart';
import 'package:food_app/pages/Login.dart';
// import 'package:food_app/pages/Login.dart';
// import 'package:food_app/pages/Splash.dart';
import 'package:food_app/pages/Url.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

String? phone;

class SignUp extends StatefulWidget {
  SignUp(text, {super.key}) {
    phone = text;
  }

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var phonenocontroller = TextEditingController(text: phone);
  final _namecontroller = TextEditingController();
  // late SharedPreferences sp;

  String? _validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? _validatePhoneNumber(value) {
    if (value!.isEmpty) {
      return 'Please enter phone number';
    }
    if (value.length != 10) {
      return 'Please enter a 10 digit Phone number';
    }
    return null;
  }

  String? _validatePassword(value) {
    if (value!.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  String? _validateUsername(value) {
    if (value!.isEmpty) {
      return 'Please enter username';
    }
    return null;
  }

  bool _obscureText = true;

  Future<void> loginStatus(
      String username, String email, String phoneno, String password) async {
    Map data = {
      "username": username,
      "email": email,
      "phoneno": phoneno,
      "password": password
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    // try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_signup.php"),
          body: data);

      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
       

        Navigator.pop(context);
        
        //sp.setBool(SplashScreenState.KEYLOGIN, true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Login()));
        Fluttertoast.showToast(
          msg: jsondata["msg"],
        );
      } else {
        Fluttertoast.showToast(
          msg: jsondata["msg"],
        );
      }
    // } catch (e) {
    //    Navigator.pop(context);
    //   Fluttertoast.showToast(
    //     msg: e.toString(),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(186, 186, 193, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/deliver.png',
                        height: 150,
                        width: 350,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                          width: 250,
                          child: Text(
                            'Create new Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 15, 14, 14)),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                          controller: _namecontroller,
                          style: const TextStyle(color: Colors.white),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              _buildInputDecoration("Name", Icons.person),
                          validator: _validateUsername),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailcontroller,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _buildInputDecoration("Email", Icons.email),
                        validator: _validateEmail,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: phonenocontroller,
                          style: const TextStyle(color: Colors.white),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: _buildInputDecoration(
                              "Phone number", Icons.numbers),
                          validator: _validatePhoneNumber),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordcontroller,
                        style: const TextStyle(color: Colors.white),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // decoration: _buildInputDecoration("Password", Icons.lock),
                        decoration: InputDecoration(
                            fillColor: const Color(0xAA494A59),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0x35949494))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            filled: true,
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 10, 10, 10),fontSize: 20,fontWeight: FontWeight.bold),
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 14, 13, 13),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        validator: _validatePassword,
                        obscureText: _obscureText,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 27, 134, 30)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginStatus(
                                    _namecontroller.text,
                                    _emailcontroller.text,
                                    phonenocontroller.text,
                                    passwordcontroller.text);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please fill all the details");
                              }
                            },
                            child: const Text("CREATE"),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData prefixIcon) {
    return InputDecoration(
        fillColor: const Color(0xAA494A59),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        filled: true,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 10, 10, 10),fontSize: 20,fontWeight: FontWeight.bold),
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
          color: const Color.fromARGB(255, 27, 26, 26),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)));
  }
}
