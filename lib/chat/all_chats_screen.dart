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
          setState(() {
            chatList = ChatList.fromJson(value);
            loading = false;
          })
        });
  }

  String formatDate(DateTime dateTime) {
    String string = "";
    DateTime local = dateTime.toLocal();
    string =
        "${getMonthName(local.month)} ${local.day.toString()} ${local.hour % 12}:${local.minute} ${local.hour > 12 ? 'PM' : 'AM'}";

    return string;
  }

  String getMonthName(int num) {
    switch (num) {
      case 1:
        return "Jan";

      case 2:
        return "Feb";

      case 3:
        return "Mar";

      case 4:
        return "Apr";

      case 5:
        return "May";

      case 6:
        return "Jun";

      case 7:
        return "Jul";

      case 8:
        return "Aug";

      case 9:
        return "Sep";

      case 10:
        return "Oct";

      case 11:
        return "Nov";

      case 12:
        return "Dec";

      default:
        return "NULL";
    }
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.chatscontact);
              },
              child: Icon(
                Icons.menu,
                size: 30,
              ),
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
                        /**
                         * @dev 
                         * send differnt route with chat id
                         */
                        Navigator.pushNamed(context, Routes.oldchat,
                            arguments: chatList.chats[index].id);
                        // Navigator.pushNamed(context, Routes.chat,
                        //     arguments: chatList.chats[index].requestId?.id);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
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
                                      "BR ${chatList.chats[index].recipentName}" ??
                                          "Test",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    chatList.chats[index].messages!.isNotEmpty
                                        ? Text(
                                            chatList.chats[index].messages![0]
                                                .content,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          )
                                        : Text("tap to chat"),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  chatList.chats[index].updatedAt != null
                                      ? formatDate(
                                          chatList.chats[index].updatedAt!)
                                      : "--",
                                  style: TextStyle(fontSize: 11),
                                )
                              ],
                            )
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
