import 'package:cun_zhi_dao/network_request.dart';

class LoginBean {
  int id = 1;
  String imgpath = '${AppNetworkRequest.baseURL}images/1.png';
  String password = '';
  String telephone = '';
  String userName = '';

  LoginBean.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    imgpath = AppNetworkRequest.baseURL + map['imgpath'];
    password = map['password'];
    telephone = map['telephone'];
    userName = map['username'];
  }
}
