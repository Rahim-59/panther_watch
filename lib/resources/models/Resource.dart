import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  final String id;
  final String title;
  final String desciption;
  final String url;

  Resource({
    required this.id,
    required this.title,
    required this.url,
    required this.desciption
  });

  factory Resource.fromDocument(DocumentSnapshot doc) {
    return Resource(
      id: doc.id,
      title: doc['title'],
      desciption: doc['description'] ?? '',
      url: doc['url']
    );
  }
}