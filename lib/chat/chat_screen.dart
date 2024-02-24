import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatData});
  final ChatData chatData;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<ChatMessage> messages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messages = widget.chatData.messages;
  }

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RQ:123221",
              style: TextStyle(fontSize: 11),
            ),
            Text("Suraj Gaire"),
          ],
        ),
        backgroundColor: Colours.mainColor,
        foregroundColor: Colours.white,
        actions: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colours.mainColor,
                  borderRadius: BorderRadius.circular(8)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.more_vert_rounded,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(
                  sender: messages[index].author,
                  text: messages[index].content,
                  isMe: messages[index].author == 'You',
                  type: messages[index].type,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
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
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
            author: "ddd", content: messageText, type: "text", status: "sent"));
        _messageController.clear();
      });
    }
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String type;

  ChatBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type == "info") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(text),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          !isMe
              ? const CircleAvatar(
                  child: Text("SG"),
                )
              : const Row(),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          isMe
              ? const CircleAvatar(
                  child: Text("SM"),
                )
              : const Row(),
        ],
      );
    }
  }
}
