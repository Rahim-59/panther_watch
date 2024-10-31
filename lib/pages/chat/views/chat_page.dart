import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panther_watch/boards/models/Board.dart';
import 'package:panther_watch/boards/services/BoardServices.dart';
import 'package:panther_watch/pages/chat/views/board_page.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Stream<List<Board>> getBoardsStream() {
    return FirebaseFirestore.instance.collection('boards').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Board.fromDocument(doc)).toList(),
    );
  }

  Future<void> createBoard(String title) async {
    final boardCollection = FirebaseFirestore.instance.collection('boards');
    await boardCollection.add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

   Future<String> getLastMessage(String boardId) async {
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('boards')
        .doc(boardId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (messagesSnapshot.docs.isNotEmpty) {
      return messagesSnapshot.docs.first['content'];
    } else {
      return 'No messages yet';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community Boards',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ElevatedButton(onPressed: () {
          //   createBoard("Clubs & Organizations");
          // }, child: Text("Board Creator")),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<Board>>(
              stream: getBoardsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading boards'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(''));
                }
            
                final boards = snapshot.data!;
            
                return ListView.builder(
                  itemCount: boards.length,
                  itemBuilder: (context, index) {
                    final board = boards[index];
                    return FutureBuilder<String>(
                      future: getLastMessage(board.id),
                      builder: (context, messageSnapshot) {
                        final lastMessage = messageSnapshot.data ?? 'Loading...';
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          title: Text(
                            board.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage,
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BoardPage(id: board.id, title: board.title)));
                          },
                        );
                      },
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
