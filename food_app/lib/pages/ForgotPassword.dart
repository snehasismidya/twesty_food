import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/pages/LoadingDialog.dart';
import 'package:food_app/pages/OtpScreen.dart';
import 'package:food_app/pages/Url.dart';
import 'package:food_app/pages/store_email.dart';

import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgotPasswordPage> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController t1 = TextEditingController();
  Future<void> check(String email) async {
    Map data = {'email': email};
    if (formkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "email_verification.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Email email = Email(jsondata["email"].toString());

          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OtpScreen(email)));
        } else {
          Navigator.of(context).pop();

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Email Id not found",
            confirmBtnText: "Ok",
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
            },
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/emailphoto.png',
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Account Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Give Your registered Email Id",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 80,
                    child: TextFormField(
                      controller: t1,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Email Your Email Id",
                        hintText: "Enter a valid Email Id",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28)),
                        prefixIcon: Icon(CupertinoIcons.mail),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email Required";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{3,4}$')
                            .hasMatch(value)) {
                          return "Please enter valid email";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () async {
                        check(t1.text);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Send Verification Code',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.deepOrange),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
