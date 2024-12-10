import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panther_watch/pages/resources/widgets/User.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<UsersPage> {

  Stream<List<OUser>> getUsersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => OUser.fromDocument(doc)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<OUser>>(
              stream: getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error loading boards'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(''));
                }
            
                final users = snapshot.data!;
            
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: TextStyle(fontSize: 14),
                          ),
                          // trailing: Icon(Icons.arrow_forward_ios),
                        );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
