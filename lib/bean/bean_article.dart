import 'package:cun_zhi_dao/network_request.dart';

class ArticleBean {
  late int id;
  late String tag;
  late String imgpath;
  late String title;
  late String text;

  ArticleBean.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tag = map['tage'];
    imgpath = AppNetworkRequest.baseURL + map['imgpath'];
    text = map['file'];
    title = map['title'];
  }
}

class ArticleBean2 {
  int id = 1;
  String text = '';
  int villageID = 1;
  String imgpath = '';
  String tag = '';

  ArticleBean2.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tag = map['tage'];
    imgpath = AppNetworkRequest.baseURL + map['imgpath'];
    villageID = map['countryside'];
    text = map['file'];
  }
}
