import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/repository/chat_repo.dart';
import 'package:nepal_blood_nexus/utils/models/chat.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  late ChatList chatList = ChatList(chats: []);
  late bool loading = true;

  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: loading,
                child: ListView.builder(
                  itemCount: chatList.chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
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
                                chatList.chats[index].recipentName ?? "Test",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                chatList.chats[index].messages![0].content ??
                                    "Last",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
