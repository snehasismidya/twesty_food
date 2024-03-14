
import 'package:flutter/material.dart';

class CustomerCarePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Care'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Open email app to contact customer support
              },
              child: Text('Contact via Email'),
            ),
            ElevatedButton(
              onPressed: () {
                // Initiate a phone call to customer support
              },
              child: Text('Call Customer Support'),
            ),
            ElevatedButton(
              onPressed: () {
                // Open a chat interface with customer support
              },
              child: Text('Chat with Support'),
            ),
          ],
        ),
      ),
    );
  }
}