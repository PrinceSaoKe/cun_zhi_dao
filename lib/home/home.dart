import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/bean/bean_article.dart';
import 'package:cun_zhi_dao/bean/bean_push.dart';
import 'package:cun_zhi_dao/custom_widgets/search_bar.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int articleCount = 5;
  List<ArticleBean> _articleBeanList = [];

  @override
  void initState() {
    super.initState();
    loadArticleData(articleCount);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    searchController.addListener(() {});

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "首页",
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: Stack(
        children: [
          // 首页背景
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/home_background.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 推送列表
          RefreshIndicator(
            color: AppTheme.appBarBackground,
            onRefresh: () async {
              loadArticleData(articleCount);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _articleBeanList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageCard(
                    coverURL: _articleBeanList[index].imgpath,
                    articleID: _articleBeanList[index].id,
                    text: _articleBeanList[index].text,
                    title: _articleBeanList[index].title,
                    tag: _articleBeanList[index].tag,
                  );
                },
              ),
            ),
          ),

          Container(height: 100, color: AppTheme.backgroundGrey),
          // 搜索框
          getSearchBarUI(),
        ],
      ),
    );
  }

  void loadArticleData(int pushCnt) async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(
      AppNetworkRequest.getPushURL,
      queryParameters: {'type': 'article', 'size': pushCnt},
    );
    var pushBean = PushBean.fromMap(response.data['data']);

    _articleBeanList = [];
    pushBean.pushList.forEach((element) async {
      my_dio.Response articleRes = await dio.get(
        AppNetworkRequest.downloadArticleURL,
        queryParameters: {'id': element},
      );
      print(articleRes.data);
      _articleBeanList.add(ArticleBean.fromMap(articleRes.data['data']));
      setState(() {});
    });
  }
}

/// 首页宣传卡片
class MessageCard extends StatelessWidget {
  String coverURL;
  int articleID;
  String title;
  String text;
  String? tag;
  MessageCard({
    super.key,
    required this.coverURL,
    required this.articleID,
    required this.title,
    required this.text,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          tag == 'video' ? AppPage.videoDetails : AppPage.articleDetails,
          arguments: {
            'id': articleID,
            'title': title,
            'text': text,
            'coverURL': coverURL,
            'tag': tag,
            'villageID': 1,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 7,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: NetworkImage(
                tag == 'video' ? AppNetworkRequest.videoCoverURL : coverURL,
              ),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
      ),
    );
  }
}
