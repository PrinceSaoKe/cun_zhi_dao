import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/bean/bean_article.dart';
import 'package:cun_zhi_dao/bean/bean_push.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCollected extends StatefulWidget {
  const MyCollected({super.key});

  @override
  State<MyCollected> createState() => _MyCollectedState();
}

class _MyCollectedState extends State<MyCollected> {
  List<ArticleBean> _list = [];
  List<bool> _checkList = [];
  bool isAdmi = false;

  @override
  void initState() {
    super.initState();
    getCollectedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的收藏',
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        actions: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.only(right: 10),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  isAdmi = !isAdmi;
                  setState(() {});
                },
                child: const Text(
                  "管理",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.messageSelfBubble,
                  ),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: myBody(),
    );
  }

  myBody() {
    if (_list.isEmpty) {
      return const Center(
        child: Text('暂时还没有收藏文章哦', style: TextStyle(fontSize: 20)),
      );
    }
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            return getcollectCard(_list[index], index);
          },
        ),
        if (isAdmi)
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: 100,
              width: 360,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          bool flag = false;
                          for (var i = 0; i < _checkList.length; i++) {
                            if (!_checkList[i]) {
                              _checkList[i] = true;
                              flag = true;
                            }
                          }
                          if (!flag) {
                            for (var i = 0; i < _checkList.length; i++) {
                              _checkList[i] = false;
                            }
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.circle,
                            color: AppTheme.appBarBackground),
                        label: const Text(
                          '全选',
                          style: TextStyle(
                            color: AppTheme.appBarBackground,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.67),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          for (var i = 0; i < _list.length; i++) {
                            if (_checkList[i]) {
                              removeCollected(_list[i].id);
                              _list.removeAt(i);
                              _checkList.removeAt(i);
                            }
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.circle),
                        label: const Text(
                          '删除',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.appBarBackground,
                          fixedSize: const Size(180, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.67),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  getcollectCard(ArticleBean bean, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppPage.articleDetails, arguments: {
                'id': bean.id,
                'title': bean.title,
                'text': bean.text,
                'coverURL': bean.imgpath,
                'villageID': 1,
                'tag': bean.tag,
              });
            },
            child: SizedBox(
              height: 85,
              width: isAdmi ? 270 : 320,
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bean.title, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 22),
                      const Text(
                        '2022-12-06',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isAdmi)
            Checkbox(
              value: _checkList[index],
              shape: const CircleBorder(),
              side:
                  const BorderSide(color: AppTheme.messageSelfBubble, width: 2),
              activeColor: AppTheme.messageSelfBubble,
              checkColor: Colors.white,
              onChanged: (value) {
                _checkList[index] = !_checkList[index];
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  // 获取收藏列表
  getCollectedList() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(
      AppNetworkRequest.getCollectedURL,
      queryParameters: {'id': AppData().currUserID},
    );
    PushBean bean = PushBean.fromMap(response.data['data']);

    _list = [];
    bean.pushList.forEach((element) async {
      my_dio.Response collectedRes = await dio.get(
        AppNetworkRequest.downloadArticleURL,
        queryParameters: {'id': element},
      );
      _list.add(ArticleBean.fromMap(collectedRes.data['data']));
      _checkList.add(false);
      setState(() {});
    });
  }

  // 取消收藏
  removeCollected(int articleID) async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.FormData formData = my_dio.FormData.fromMap({
      'article_id': articleID,
      'user_id': AppData().currUserID,
    });
    my_dio.Response response = await dio.post(
      AppNetworkRequest.removeCollectedURL,
      data: formData,
    );
    setState(() {});
  }
}
