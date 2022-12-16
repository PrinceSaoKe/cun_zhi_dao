import 'package:cun_zhi_dao/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class VillageDetailsPage extends StatefulWidget {
  const VillageDetailsPage({super.key});

  @override
  State<VillageDetailsPage> createState() => _VillageDetailsPageState();
}

class _VillageDetailsPageState extends State<VillageDetailsPage> {
  String imgURL = Get.arguments['imageURL'];
  String title = Get.arguments['name'];
  int id = Get.arguments['id'];
  String text = Get.arguments['text'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      body: ListView(
        children: [
          GFCarousel(
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            // 放大当前页的轮播图
            enlargeMainPage: true,
            // 显示索引小圆点
            hasPagination: true,
            activeIndicator: AppTheme.messageSelfBubble,
            passiveIndicator: AppTheme.appBarBackground,
            items: [
              Image(image: NetworkImage(imgURL), fit: BoxFit.cover),
              Image(image: NetworkImage(imgURL), fit: BoxFit.cover),
              Image(image: NetworkImage(imgURL), fit: BoxFit.cover),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "村庄简介",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(text, textAlign: TextAlign.start),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
