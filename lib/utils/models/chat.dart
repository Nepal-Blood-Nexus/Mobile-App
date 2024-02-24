class ChatMessage {
  String? id;
  final String content;
  final String author;
  final String type;
  final String status;
  String? messageId;

  ChatMessage({
    this.id,
    required this.content,
    required this.author,
    required this.type,
    required this.status,
    this.messageId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      content: json['message'][0]['content'],
      author: json['message'][0]['author'],
      type: json['message'][0]['type'],
      status: json['message'][0]['status'],
      messageId: json['message'][0]['_id'],
    );
  }
}

class ChatData {
  final String id;
  final List<ChatMessage> messages;
  final String requestId;
  final String userA;
  final String userB;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatData({
    required this.id,
    required this.messages,
    required this.requestId,
    required this.userA,
    required this.userB,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['_id'],
      messages: [
        ChatMessage.fromJson(json),
      ],
      requestId: json['requestid'],
      userA: json['usera'],
      userB: json['userb'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
