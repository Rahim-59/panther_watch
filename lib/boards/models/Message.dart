class Message {
  final String id;
  final String author;
  final String created;
  final String board;
  final String content;

  Message({
    required this.id,
    required this.author,
    required this.created,
    required this.content,
    required this.board
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      author: json['author'],
      created: json['created'],
      board: json['board'],
      content: json['content']
    );
  }
  
}