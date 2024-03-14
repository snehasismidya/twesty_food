import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/firebase_options.dart';
import 'package:food_app/pages/Splash.dart';
import 'package:food_app/pages/otp.dart';
import 'package:food_app/pages/phone.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen (),
    getPages: [
      GetPage(
        name: '/otp',
        page: () => const MyOtp(),
      )
    ],
    routes: {
      'phone': (context) => const MyPhone(),
      'otp': (context) => const MyOtp()
    },
  ));
}
