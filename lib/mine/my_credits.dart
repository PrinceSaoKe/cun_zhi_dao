import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/bean/bean_gift.dart';
import 'package:cun_zhi_dao/bean/bean_push.dart';
import 'package:cun_zhi_dao/custom_widgets/user_details.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';

class MyCredits extends StatefulWidget {
  const MyCredits({super.key});

  @override
  State<MyCredits> createState() => _MyCreditsState();
}

class _MyCreditsState extends State<MyCredits> {
  List<GiftBean> _giftBeanList = [];
  List<Widget> _giftCardList = [];

  @override
  void initState() {
    super.initState();
    getGiftList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的积分',
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: myBody(),
    );
  }

  myBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      children: [
        AccountBar(
          detail: '当前积分: 11',
        ),
        const Text(
          "兑换商城",
          style: TextStyle(color: AppTheme.messageSelfBubble, fontSize: 25),
        ),
        const SizedBox(height: 12),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: _giftCardList),
          ),
        ),
      ],
    );
  }

  // 礼品卡片
  getGiftCard(GiftBean giftBean) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(giftBean.imgpath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  // 获取所有礼品
  getGiftList() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(AppNetworkRequest.getAllGiftURL);
    print(response.data);

    _giftBeanList = [];
    PushBean pushBean = PushBean.fromMap(response.data['data']);
    pushBean.pushList.forEach((element) {
      _giftBeanList.add(GiftBean.fromMap(element));
    });
    setState(() {});
    initGiftCardList();
  }

  // 初始化卡片列表
  initGiftCardList() async {
    _giftCardList = [];
    _giftBeanList.forEach((element) {
      _giftCardList.add(getGiftCard(element));
    });
    setState(() {});
  }
}
