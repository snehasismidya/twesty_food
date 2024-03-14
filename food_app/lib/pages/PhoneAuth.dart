import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:food_app/pages/Signup.dart';
import 'package:food_app/pages/otp.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class authWithNumber extends GetxController {
  bool otpmatch = false;

  TextEditingController number = TextEditingController();
  TextEditingController otp = TextEditingController();

  String verifyId = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  void signUpWithNumber() async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: "+91${number.text}",
          

          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) {
            verifyId = verificationId;
            
            Get.snackbar("OTP Sended",
                "OTP Sended on your mobile number ${number.text}");
            Get.to(const MyOtp());
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
      Get.toNamed("/otp");
    } on FirebaseAuthException catch (e) {
      Get.snackbar(e.toString(), "");
    }
  }

  Future<int> verifyMobileNumber() async {

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifyId, smsCode: otp.text);

      await auth.signInWithCredential(credential);
     

      Get.snackbar("OTP Verified", "Welcome to flutter app");

      Get.offAll(SignUp(number.text));

    //  var sp = await SharedPreferences.getInstance();
    //     sp.setBool("login", true);

    } catch (e) {
      Get.snackbar(e.toString(), "");
    }
    return 0;
  }
}
