import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/repository/chat_repo.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/models/chat.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  late ChatList chatList =
      ChatList(chats: List.filled(5, ChatData(messages: [])));
  late bool loading = true;

  @override
  void initState() {
    super.initState();
    loading = true;
    GetChats().then((value) => {
          print(value),
          setState(() {
            chatList = ChatList.fromJson(value);
            loading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            child: Icon(
              Icons.search,
              size: 30,
            ),
          ),

          centerTitle: true,
          // titleSpacing: 20,
          toolbarHeight: 80,
          backgroundColor: Colours.mainColor,
          foregroundColor: Colours.white,
          actions: [
            Icon(
              Icons.menu,
              size: 30,
            ),
            SizedBox(
              width: 10,
            )
          ],
          title: Text("MESSAGES"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatList.chats.length,
                itemBuilder: (BuildContext context, int index) {
                  return Skeletonizer(
                    enabled: loading,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.chat,
                            arguments: chatList.chats[index].requestId?.id);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            border: BorderDirectional(
                                top: BorderSide(
                                    width: 0.3, color: Colors.black45))),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 9),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.account_circle),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BR ${chatList.chats[index].requestId?.initiator?.fullname}" ??
                                      "Test",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                chatList.chats[index].messages!.isNotEmpty
                                    ? Text(
                                        chatList
                                            .chats[index].messages![0].content,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      )
                                    : Text("tap to chat"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
