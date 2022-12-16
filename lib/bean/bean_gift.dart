import 'package:cun_zhi_dao/network_request.dart';

class GiftBean {
  late int id;
  String name = '';
  String imgpath = '';
  String imgflag = 'image';

  GiftBean.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    imgpath = AppNetworkRequest.baseURL + map['imgpath'];
    imgflag = map['imgflag'];
  }
}
