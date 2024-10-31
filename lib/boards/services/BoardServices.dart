
import 'package:cloud_firestore/cloud_firestore.dart';

class BoardService {

  static Future<void> createBoard(String title) async {
    final boardCollection = FirebaseFirestore.instance.collection('boards');
    await boardCollection.add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> addMessage(String boardId, String content, String author) async {
    final messagesCollection = FirebaseFirestore.instance
        .collection('boards')
        .doc(boardId)
        .collection('messages');

    await messagesCollection.add({
      'content': content,
      'author': author,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<QueryDocumentSnapshot>> getBoards() {
    return FirebaseFirestore.instance.collection('boards').snapshots().map(
      (snapshot) => snapshot.docs,
    );
  }

  static Stream<List<QueryDocumentSnapshot>> getMessages(String boardId) {
    return FirebaseFirestore.instance
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }


}