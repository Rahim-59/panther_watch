
import 'package:cloud_firestore/cloud_firestore.dart';

class OUser {
  final String id;
  final String email;
  final String username;
  final String type;

  OUser({required this.id, required this.email, required this.username, required this.type});

  factory OUser.fromDocument(DocumentSnapshot doc) {
    return OUser(id: doc.id, email: doc['email'], username: doc['username'], type: doc['type']);
  }
}