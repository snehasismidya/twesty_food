import 'package:flutter/material.dart';
import 'package:food_app/pages/Login.dart';
import 'package:food_app/pages/PhoneAuth.dart';
import 'package:get/get.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({super.key});

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  authWithNumber cn = Get.put(authWithNumber());

  TextEditingController countrycode = TextEditingController();
  TextEditingController phno = TextEditingController();


  String? _validatePhoneNumber(value) {
    if (value!.isEmpty) {
      return 'Please enter phone number';
    }
    if (value.length != 10) {
      return 'Please enter a 10 digit Phone number';
    }
    return null;
  }
     
  

  var phone = "";
  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/phone.jpg',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Phone Verification',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'You need to register your phone before getting started !',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 40,
                      child: TextField(
                      enabled: false,
                        controller: countrycode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    '|',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                        
                    controller: cn.number,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      phone = value;
                    },
                    decoration: const InputDecoration(
                      
                        border: InputBorder.none, hintText: 'Phone number'),
                        
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    cn.signUpWithNumber();
                  },
                  child: const Text('Send the code'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(6, 245, 10, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an Account?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    TextButton(onPressed: (){

                      Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>Login()));
                    }, child: Text('Log in'))
                  ],
                )
          ]),
        ),
      ),
    );
  }
}
