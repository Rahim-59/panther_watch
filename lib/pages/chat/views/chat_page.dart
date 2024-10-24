import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final List<Map<String, String>> boards = [
    {
      'title': 'General Discussion',
      'lastComment': 'Last comment by Alice: "I totally agree!"'
    },
    {
      'title': 'Tech Talk',
      'lastComment': 'Last comment by Bob: "Check out the new updates."'
    },
    {
      'title': 'Flutter Developers',
      'lastComment':
          'Last comment by Carol: "How do I handle state management?"'
    },
    {
      'title': 'Flutter Developers',
      'lastComment':
          'Last comment by Carol: "How do I handle state management?"'
    },
    {
      'title': 'General Discussion',
      'lastComment': 'Last comment by Alice: "I totally agree!"'
    },
    {
      'title': 'Tech Talk',
      'lastComment': 'Last comment by Bob: "Check out the new updates."'
    },
    {
      'title': 'Flutter Developers',
      'lastComment':
          'Last comment by Carol: "How do I handle state management?"'
    },
    {
      'title': 'General Discussion',
      'lastComment': 'Last comment by Alice: "I totally agree!"'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: boards.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => Divider(
                  // Divider between each ListTile
                  thickness: 1, // Thickness of the divider
                  color: Colors.grey, // Color of the divider
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text(
                      boards[index]['title']!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      boards[index]['lastComment']!,
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios), // Trailing arrow icon
                    onTap: () {
                      // Define what happens when the tile is tapped
                      print('Tapped on ${boards[index]['title']}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
