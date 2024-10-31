import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panther_watch/boards/models/Message.dart';

class Board {
  final String id;
  final String title;

  Board({
    required this.id,
    required this.title,
  });

  factory Board.fromDocument(DocumentSnapshot doc) {
    return Board(
      id: doc.id,
      title: doc['title'],
    );
  }
}