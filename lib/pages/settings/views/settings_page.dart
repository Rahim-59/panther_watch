
import 'package:flutter/material.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';
import 'package:panther_watch/pages/login/login.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
              ListTile(
                  title: Text('Logout',
                  style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  onTap: (){
                    AuthService.logout();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  trailing: Icon(Icons.logout),
              )
          ],
        ),
      ),
    );
  }
}