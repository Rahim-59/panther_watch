import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String id;
  final double latitude;
  final double longitude;
  final String username;
  final Timestamp timestamp;
  final bool active;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.username,
    required this.timestamp,
    required this.active,
  });

  factory Location.fromDocument(DocumentSnapshot doc) {
    return Location(
      id: doc.id,
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      username: doc['username'],
      timestamp: doc['timestamp'],
      active: doc['active']
    );
  }
}