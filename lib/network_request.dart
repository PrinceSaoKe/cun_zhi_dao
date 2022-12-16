import 'package:cun_zhi_dao/app_data.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:get/get.dart';

class AppNetworkRequest {
  static my_dio.Dio dio = my_dio.Dio();
  static const String baseURL = "http://120.78.147.187:80/";
  static const String passwordLoginURL = "${baseURL}login/";
  static const String telephoneLoginURL = "${baseURL}login_telephone/";
  static const String registerURL = "${baseURL}register/";
  static const String adminRegisterURL = "${baseURL}admin_register/";
  static const String sendPinURL = "${baseURL}send_text/";
  static const String deleteUserURL = "${baseURL}delete/";
  static const String uploadArticleURL = "${baseURL}upload_article/";
  static const String downloadArticleURL = "${baseURL}download_article/";
  static const String searchArticleURL = "${baseURL}search/";
  static const String searchByTagURL = "${baseURL}search_by_tag/";
  static const String uploadImageURL = "${baseURL}upload_image/";
  static const String downloadImageURL = "${baseURL}download_image/";
  static const String getPushURL = "${baseURL}command/";
  static const String collectArticleURL = "${baseURL}collect_articles/";
  static const String removeCollectedURL = "${baseURL}remove_articles/";
  static const String getCollectedURL = "${baseURL}get_collect/";
  static const String checkCollectedURL = "${baseURL}check_collect/";
  static const String getCreditURL = "${baseURL}get_user_number/";
  static const String addCreditURL = "${baseURL}upload_user_number/";
  static const String exchangeGiftURL = "${baseURL}get_gift/";
  static const String uploadGiftURL = "${baseURL}upload_gift/";
  static const String removeGiftURL = "${baseURL}remove_gift/";
  static const String getAllGiftURL = "${baseURL}get_all_gift/";
  static const String getOneGiftURL = "${baseURL}get_one_gift/";
  static const String uploadVillageURL = "${baseURL}upload_contryside/";
  static const String downloadVillageURL = "${baseURL}download_countryside/";
  static const String videoCoverURL = "${baseURL}images/video_cover.png/";

  formatError(my_dio.DioError e) {
    String error;

    if (e.type == my_dio.DioErrorType.connectTimeout) {
      error = "连接超时";
    } else if (e.type == my_dio.DioErrorType.sendTimeout) {
      error = "请求超时";
    } else if (e.type == my_dio.DioErrorType.receiveTimeout) {
      error = "响应超时";
    } else if (e.type == my_dio.DioErrorType.response) {
      error = "出现异常";
    } else if (e.type == my_dio.DioErrorType.cancel) {
      error = "请求取消";
    } else {
      error = "未知错误";
    }

    Get.snackbar('网络请求错误', error);
  }

  static addCredit(int creditToAdd) async {
    my_dio.FormData formData = my_dio.FormData.fromMap({
      'id': AppData().currUserID,
      'number': creditToAdd,
    });
    my_dio.Response response = await dio.post(
      AppNetworkRequest.addCreditURL,
      data: formData,
    );
    print(response);
  }
}
