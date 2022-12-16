import 'package:cun_zhi_dao/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "消息",
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          MessageCard(friendName: "嗡嗡"),
          MessageCard(friendName: "好友昵称待传参"),
          MessageCard(friendName: "好友昵称待传参"),
          MessageCard(friendName: "好友昵称待传参"),
          MessageCard(friendName: "好友昵称待传参"),
          MessageCard(friendName: "好友昵称待传参"),
          MessageCard(friendName: "好友昵称待传参"),
        ],
      ),
    );
  }
}

// 消息卡片
class MessageCard extends StatelessWidget {
  String friendName;
  MessageCard({super.key, required this.friendName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/chat", arguments: {"title": friendName});
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 7,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/friend_1.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
                width: 20,
              ),
              SizedBox(
                width: 215,
                height: 50,
                // color: Colors.red,
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        friendName,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "消息内容",
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
