
import 'package:flutter/material.dart';
import 'package:panther_watch/authentication/service/AuthService.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  String username = '';
  String email = '';
  String type = '';

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  void _getInfo() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await AuthService.getUserDetails();

      if (response != null) {
        setState(() {
          username = response['username'];
          email = response['email'];
          type = response['type'];
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text('Profile'),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(200)
                  ),
                ),
                SizedBox(height: 20),
                Text(username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                Text(email, style: TextStyle(),),
                Text(type, style: TextStyle(color: Colors.grey, fontSize: 16),),
              ],
            ),
          ),
        ),
        if (isLoading) Container(color: const Color.fromARGB(54, 0, 0, 0), child: Center(child: CircularProgressIndicator(color: Colors.white,)))
      ],
    );
  }
}