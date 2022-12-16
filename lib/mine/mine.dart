import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/custom_widgets/user_details.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "我的",
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            AccountBar(),
            const MineCard(),
          ],
        ),
      ),
    );
  }
}

// “我的”卡片栏
class MineCard extends StatelessWidget {
  const MineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              MineCardOption(text: "我的收藏", toNamedPage: AppPage.myCollected),
              MineCardOption(text: "我的积分", toNamedPage: AppPage.myCredits),
              MineCardOption(text: "发布文章", toNamedPage: AppPage.uploadArticle),
              MineCardOption(text: "切换账号", toNamedPage: AppPage.login),
              MineCardOption(text: "测试页面", toNamedPage: AppPage.test),
            ],
          ),
        ),
      ),
    );
  }
}

// “我的”卡片选项
class MineCardOption extends StatelessWidget {
  String text;
  String toNamedPage;
  MineCardOption({super.key, required this.text, required this.toNamedPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(toNamedPage, arguments: {"title": text});
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Card(
          color: AppTheme.buttonColor,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
            child: SizedBox(
              width: 80,
              height: 25,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
