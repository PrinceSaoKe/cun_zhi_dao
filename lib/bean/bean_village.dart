import 'package:cun_zhi_dao/network_request.dart';

class VillageBean {
  late int id;
  late String name;
  late String article;
  late String imgpath;

  VillageBean.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    article = map['article'];
    imgpath = AppNetworkRequest.baseURL + map['imgpath'];
  }
}
