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

class ChatScreenOld extends StatefulWidget {
  const ChatScreenOld({super.key, required this.chatid});
  final String chatid;

  @override
  State<ChatScreenOld> createState() => _ChatScreenOldState();
}

class _ChatScreenOldState extends State<ChatScreenOld> {
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
    await getChat(widget.chatid).then((value) => {
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

    debugPrint(pusherChannelsFlutter.connectionState);
    pusherChannelsFlutter.onEvent = onEvent;
  }

  void onEvent(PusherEvent event) {
    try {
      var message = jsonDecode(event.data);

      setState(() {
        if (message["chatid"] == chatData.id && message["author"] != user.id) {
          messages.add(
            ChatMessage(
                content: message["content"],
                author: message["author"],
                type: message["type"],
                status: "sent"),
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
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
                chatData.requestId?.id ?? "hhh",
                style: const TextStyle(fontSize: 11),
              ),
              Text(chatData.recipentName ?? "LOADING"),
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 9,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    pusherChannelsFlutter.connectionState,
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
            padding:
                const EdgeInsets.only(left: 7, right: 7, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chatData.requestId?.bloodGroup ?? ""),
                    Text(
                      chatData.requestId?.location ?? "",
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                Text(
                  chatData.requestId?.status ?? "",
                  style: const TextStyle(
                    color: Colours.mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
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
                  avatar: chatData.recipentName!,
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
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
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
  final String avatar;

  ChatBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.type,
    required this.showAvatar,
    required this.avatar,
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
            style: const TextStyle(fontSize: 10),
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
              ? CircleAvatar(
                  child: Icon(Icons.face_5_rounded),
                )
              : const SizedBox(
                  width: 40,
                ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 9),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color.fromARGB(255, 252, 94, 94)
                    : const Color.fromARGB(255, 40, 39, 39),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14.0, color: Colours.white),
              ),
            ),
          ),
          (isMe && showAvatar)
              ? const CircleAvatar(
                  child: Icon(Icons.face_5_rounded),
                )
              : const SizedBox(
                  width: 40,
                ),
        ],
      );
    } else {
      return const Text("data");
    }
  }
}
