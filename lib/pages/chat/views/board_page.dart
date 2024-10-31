import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  final String id;
  final String title;

  const BoardPage({super.key, required this.id, required this.title});

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final TextEditingController _messageController = TextEditingController();

  Stream<List<DocumentSnapshot>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('boards')
        .doc(widget.id)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return; 
    await FirebaseFirestore.instance
        .collection('boards')
        .doc(widget.id)
        .collection('messages')
        .add({
      'content': content,
      'author': 'Anonymous', 
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading messages'));
                }
                // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //   return Center(child: Text('No messages available'));
                // }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true, // Start from the bottom for latest message
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['author']),
                      subtitle: Text(message['content']),
                      trailing: Text(message['timestamp']?.toDate().toString() ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(_messageController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
