import 'package:cloud_firestore/cloud_firestore.dart';

class Resourcecategory {
  final String id;
  final String title;

  Resourcecategory({
    required this.id,
    required this.title,
  });

  factory Resourcecategory.fromDocument(DocumentSnapshot doc) {
    return Resourcecategory(
      id: doc.id,
      title: doc['title'],
    );
  }
}