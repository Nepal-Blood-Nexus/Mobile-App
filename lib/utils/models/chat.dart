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
      content: json['content'],
      author: json['author'],
      type: json['type'],
      status: json['status'],
      messageId: json['_id'],
    );
  }
}

class ChatData {
  final String? id;
  final List<ChatMessage>? messages;
  final String? requestId;
  final String? recipentName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatData({
    this.id,
    this.messages,
    this.requestId,
    this.recipentName,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> msg = (json['message'] as List<dynamic>)
        .map((data) => ChatMessage.fromJson(data as Map<String, dynamic>))
        .toList();

    return ChatData(
      id: json['_id'],
      messages: msg,
      requestId: json['requestid'],
      recipentName: json['recipentName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ChatList {
  final List<ChatData> chats;

  ChatList({
    required this.chats,
  });

  factory ChatList.fromJson(List<dynamic> json) {
    List<ChatData> chats = json.map((data) => ChatData.fromJson(data)).toList();
    return ChatList(chats: chats);
  }
}


// {_id: 65d84b23e2b7da3ec3738eba, message: [{content: chat reference, author: 65d2ef0a61fc5220378a1efb, type: info, status: sent, _id: 65d84b23e2b7da3ec3738ebb}], requestid: 65d48eca46428578a5beee4f, usera: 65d2ef0a61fc5220378a1efb, userb: 65d48e5bde2fe45add3473ad, createdAt: 2024-02-23T07:37:07.742Z, updatedAt: 2024-02-23T07:37:07.742Z, __v: 0}

