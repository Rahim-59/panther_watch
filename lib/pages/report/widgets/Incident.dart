import 'package:cloud_firestore/cloud_firestore.dart';

class Incident {
  final String id;
  final String title;
  final String doi;
  final String department;
  final String email;
  final String incident_description;
  final String name;
  final String phone;
  final String toi;
  final Timestamp timestamp;


  Incident({
    required this.id,
    required this.title,
    required this.doi,
    required this.department,
    required this.email,
    required this.incident_description,
    required this.name,
    required this.phone,
    required this.toi,
    required this.timestamp
  });

  factory Incident.fromDocument(DocumentSnapshot doc) {
    return Incident(
      id: doc.id,
      title: doc['title'],
      incident_description: doc['incident_description'],
      department: doc['department'],
      email: doc['email'],
      phone: doc['phone'],
      name: doc['name'],
      toi: doc['time_of_incident'],
      doi: doc['date_of_incident'],
      timestamp: doc['timestamp'],
    );
  }

}