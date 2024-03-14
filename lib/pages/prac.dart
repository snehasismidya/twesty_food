// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';


class Practice extends StatelessWidget {
  Practice({super.key});
  var name = TextEditingController();
  var pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                      borderSide: BorderSide(color: Colors.amberAccent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 11, 4, 119))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 255, 64, 64))),
                )),
            Container(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: '*',
              controller: pass,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    String uName = name.text;
                    String uPass = pass.text;
                    print("Name:$uName,Password$uPass");
                  },
                  child: Text('TextButton'),
                ),
              ],
        ),
      )),
    );
  }
}
