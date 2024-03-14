import 'package:flutter/material.dart';
//import 'package:mock_test/utils/appcolors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 80,
            width: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 126, 123, 123),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                
                 CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.green)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading....",
                  style: TextStyle(fontSize: 8, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}