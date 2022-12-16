import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.arguments["title"],
          style: const TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: Stack(
        children: [
          ListView(),
          const ChatBelow(),
        ],
      ),
    );
  }
}

class ChatBelow extends StatelessWidget {
  const ChatBelow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        height: 75,
        width: MediaQuery.of(context).size.width,
        color: AppTheme.appBarBackground,
        child: Row(
          children: [
            Container(),
          ],
        ),
      ),
    );
  }
}
