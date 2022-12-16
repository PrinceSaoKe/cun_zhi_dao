import 'package:cun_zhi_dao/network_request.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppData extends GetxController {
  final box = GetStorage();
  int get currUserID => int.parse(box.read('currUserID'));
  String get currUserName => box.read('currUserName');
  String get currUserAvatar => box.read('currUserAvatar');

  checkData() {
    if (box.read('currUserAvatar') == null) {
      box.write('currUserAvatar', '${AppNetworkRequest.baseURL}images/1.png');
    }
    if (box.read('currUserID') == null) {
      box.write('currUserID', 1);
    }
    if (box.read('currUserName') == null) {
      box.write('currUserName', '无名氏');
    }
  }
}
