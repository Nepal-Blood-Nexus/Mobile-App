import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepal_blood_nexus/repository/chat_repo.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/chat.dart';
import 'package:nepal_blood_nexus/utils/models/user.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

const storage = FlutterSecureStorage();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.requestid});
  final String requestid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<ChatMessage> messages;
  late ChatData chatData;
  late User user;
  bool loading = true;
  final ScrollController _scrollController = ScrollController();

  PusherChannelsFlutter pusherChannelsFlutter =
      PusherChannelsFlutter.getInstance();

  Future<void> hook() async {
    String? userString = await storage.read(key: "user");
    setState(() {
      user = User.fromJson(jsonDecode(userString!));
    });
    await initiateChatwithRequest(widget.requestid).then((value) => {
          setState(() {
            chatData = ChatData.fromJson(value);
            messages = ChatData.fromJson(value).messages!;
            loading = false;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    chatData = ChatData();
    messages = [];
    user = User();
    hook();

    print(pusherChannelsFlutter.connectionState);
    pusherChannelsFlutter.onEvent = onEvent;
  }

  void onEvent(PusherEvent event) {
    try {
      var message = jsonDecode(event.data);
      print(message);
      setState(() {
        messages.add(
          ChatMessage(
              content: message["content"],
              author: message["author"],
              type: message["type"],
              status: "sent"),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Skeletonizer(
          enabled: loading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatData.requestId ?? "hhh",
                style: TextStyle(fontSize: 11),
              ),
              Text(chatData.recipentName ?? "Sring"),
            ],
          ),
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
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(115, 244, 151, 151),
                shape: BoxShape.rectangle),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 9,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    pusherChannelsFlutter.connectionState,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(
                  sender: messages[index].author,
                  text: messages[index].content,
                  isMe: messages[index].author == user.id,
                  type: messages[index].type,
                  showAvatar: (index > 1 &&
                          messages[index].author == messages[index - 1].author)
                      ? false
                      : true,
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
            author: user.id!,
            content: messageText,
            type: "text",
            status: "sent"));
        _messageController.clear();
        sendMsg(messageText, chatData.id);
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
  final bool showAvatar;

  ChatBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.type,
    required this.showAvatar,
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
          Text(
            text,
            style: TextStyle(fontSize: 10),
          ),
        ],
      );
    }

    if (type == "text") {
      return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          (!isMe && showAvatar)
              ? const CircleAvatar(
                  child: Text("SG"),
                )
              : const Row(),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 9),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color:
                    isMe ? Color.fromARGB(255, 252, 94, 94) : Colors.grey[300],
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 14.0, color: Colours.white),
              ),
            ),
          ),
          (isMe && showAvatar)
              ? const CircleAvatar(
                  radius: 15,
                  child: Text("SM"),
                )
              : const SizedBox(
                  width: 30,
                ),
        ],
      );
    } else {
      return Text("data");
    }
  }
}
