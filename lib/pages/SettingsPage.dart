import 'package:flutter/material.dart';



class SettingsPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Edit Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                // Navigate to profile editing screen
              },
            ),
            ListTile(
              title: Text('Change Password'),
              leading: Icon(Icons.lock),
              onTap: () {
                // Navigate to password change screen
              },
            ),
            Divider(),
            Text(
              'App Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Navigate to notifications settings
              },
            ),
            ListTile(
              title: Text('Dark Mode'),
              leading: Icon(Icons.brightness_4),
              trailing: Switch(
                value: true, // Replace with actual value
                onChanged: (value) {
                  // Handle dark mode toggle
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
