import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// 账户头像栏
class AccountBar extends StatelessWidget {
  String detail;
  bool canChangeAvatar;
  XFile? imageFile;
  AccountBar({super.key, this.detail = '', this.canChangeAvatar = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // TODO 更改头像对话框
              if (!canChangeAvatar) return;
              Get.defaultDialog(
                title: '点击更改头像',
                content: GestureDetector(
                  onTap: () {
                    myPickImage();
                  },
                  child: Image.network(AppData().currUserAvatar),
                ),
              );
            },
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(37.5),
                image: DecorationImage(
                  image: NetworkImage(AppData().currUserAvatar),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.low,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: SizedBox(
              width: 150,
              height: 75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '昵称：${AppData().currUserName}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 24),
                  Text(detail),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  myPickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      my_dio.Dio dio = my_dio.Dio();
      my_dio.FormData formData = my_dio.FormData.fromMap({
        "id": AppData().currUserID,
        "file": await my_dio.MultipartFile.fromFile(image.path),
        'type': 'user',
        'flag': 'image',
      });
      my_dio.Response response =
          await dio.post(AppNetworkRequest.uploadImageURL, data: formData);
      print(response.data);
      // Get.snackbar(response.data['message'], response.data['data']);
      Get.back();
      AppData().box.write(
            'currUserAvatar',
            AppNetworkRequest.baseURL + response.data['data']['url'],
          );
    }
  }
}
