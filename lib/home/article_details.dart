import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/bean/bean_article.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleDetailsPage extends StatefulWidget {
  const ArticleDetailsPage({super.key});

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  int villageID = Get.arguments['villageID'];
  String tag = Get.arguments['tag'];

  int articleID = 1;
  String text = '';
  String title = Get.arguments['tag'];
  String coverURL = '';
  bool isCollected = false;

  @override
  void initState() {
    super.initState();
    isCollected = false;
    checkCollected();
    searchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: AppTheme.appBarTitle)),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isCollected) {
            collectArticle();
          } else {
            removeCollected(articleID);
          }
        },
        child: Icon(
          isCollected ? Icons.star : Icons.star_border,
          color: Colors.white,
          size: 30,
        ),
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: myBody(),
    );
  }

  myBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      children: [
        coverURL == ''
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.appBarBackground,
                  ),
                ),
              )
            : Image(image: NetworkImage(coverURL)),
        const SizedBox(height: 20),
        Text(text),
      ],
    );
  }

  // 搜索文章
  searchArticle() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.FormData formData = my_dio.FormData.fromMap({
      'tage': tag,
      'countryside': villageID,
    });
    my_dio.Response response =
        await dio.post(AppNetworkRequest.searchByTagURL, data: formData);
    print('搜索文章返回:');
    print(response.data);
    ArticleBean2 bean = ArticleBean2.fromMap(response.data['data']);
    articleID = bean.id;
    text = bean.text;
    coverURL = bean.imgpath;
    setState(() {});
  }

  // 下载文章
  getArticle() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(
      AppNetworkRequest.downloadArticleURL,
      queryParameters: {'id': articleID},
    );
  }

  // 检查文章是否已被收藏
  Future<bool> checkCollected() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(
      AppNetworkRequest.checkCollectedURL,
      queryParameters: {
        'user_id': AppData().currUserID,
        'article_id': articleID,
      },
    );
    setState(() {
      isCollected = response.data['result'];
    });
    return response.data['result'];
  }

  // 收藏文章
  collectArticle() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.FormData formData = my_dio.FormData.fromMap({
      'article_id': articleID,
      'user_id': AppData().currUserID,
    });
    my_dio.Response response =
        await dio.post(AppNetworkRequest.collectArticleURL, data: formData);
    print(response.data);
    setState(() {
      isCollected = true;
    });
    Get.snackbar('收藏成功！', '文章《$title》已收藏');
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
    setState(() {
      isCollected = false;
    });
    Get.snackbar('已取消收藏！', '已将文章《$title》移出收藏列表');
  }
}
