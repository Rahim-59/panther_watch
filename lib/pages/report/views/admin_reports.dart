import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panther_watch/boards/models/Board.dart';
import 'package:panther_watch/boards/services/BoardServices.dart';
import 'package:panther_watch/pages/chat/views/board_page.dart';
import 'package:panther_watch/pages/report/widgets/Incident.dart';

class ReportsPage extends StatefulWidget {
  @override
  State<ReportsPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ReportsPage> {

  Stream<List<Incident>> getReportsStream() {
    return FirebaseFirestore.instance.collection('incidents').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Incident.fromDocument(doc)).toList(),
    );
  }

  void viewDetails(Incident incident) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(incident.title + ' - ' + incident.timestamp.toDate().toString()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(incident.doi),
              Text(incident.toi),
              SizedBox(height: 20),
              Text('Department: ' + incident.department),
              Text('Email: ' + incident.email),
              Text('Phone: ' + incident.phone),
              Text('Name of reporter: ' + incident.name),
              Text('Description: ' + incident.incident_description),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Incident>>(
              stream: getReportsStream(),
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
            
                final incidents = snapshot.data!;
            
                return ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    final incident = incidents[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            incident.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            incident.incident_description,
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            viewDetails(incident);
                          }
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
