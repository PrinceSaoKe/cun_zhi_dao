import 'dart:io';

import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/custom_widgets/dialog.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as my_get;
import 'package:image_picker/image_picker.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  XFile? imageFile;
  TextEditingController firstCtrl = TextEditingController();
  TextEditingController secondCtrl = TextEditingController();
  TextEditingController thirdCtrl = TextEditingController();
  TextEditingController forthCtrl = TextEditingController();
  String downImageURL = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "测试页面",
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: ListView(
        children: [
          // 刷新按钮
          ElevatedButton(
            onPressed: () {
              alertDialog(context);
            },
            child: const Text('刷新'),
          ),

          // 显示用户信息
          ElevatedButton(
            onPressed: () {
              my_get.Get.snackbar(
                "用户信息",
                {
                  "用户编号": AppData().currUserID,
                  "用户名": AppData().currUserName,
                  "用户电话": AppData().box.read('currUserTele'),
                  '头像地址': AppData().currUserAvatar,
                }.toString(),
              );
            },
            child: const Text("显示当前用户信息"),
          ),

          // 显示设备数据
          ElevatedButton(
            onPressed: () {
              my_get.Get.snackbar(
                  '',
                  (MediaQuery.of(context).size *
                          MediaQuery.of(context).devicePixelRatio)
                      .toString());
            },
            child: const Text('显示设备数据'),
          ),

          // 输入框
          TextField(
            controller: firstCtrl,
          ),
          TextField(
            controller: secondCtrl,
          ),
          TextField(
            controller: thirdCtrl,
          ),
          TextField(
            controller: forthCtrl,
          ),

          // 选择图片
          ElevatedButton(
            onPressed: () {
              myPickImage();
            },
            child: const Text("选择图片"),
          ),

          // 图片
          imageFile == null
              ? const Text("无图片")
              : Image.file(File(imageFile!.path)),

          // 上传为头像
          if (imageFile != null)
            ElevatedButton(
              onPressed: () {
                uploadImage(firstCtrl, 'user');
              },
              child: const Text("上传为当前用户的头像"),
            ),

          // 上传为文章图片
          if (imageFile != null)
            ElevatedButton(
              onPressed: () {
                uploadImage(firstCtrl, 'article');
              },
              child: const Text("上传为文章图片,1为文章id"),
            ),

          // 上传为村庄
          if (imageFile != null)
            ElevatedButton(
              onPressed: () {
                uploadImage(firstCtrl, 'countryside');
              },
              child: const Text("上传为村庄图片, 输入1为村庄id"),
            ),

          // 上传为礼品
          if (imageFile != null)
            ElevatedButton(
              onPressed: () {
                uploadImage(firstCtrl, 'gift');
              },
              child: const Text("上传为礼品图片"),
            ),

          // 上传文章
          if (imageFile != null)
            ElevatedButton(
              onPressed: () {
                uploadArticle();
              },
              child: const Text("上传文章, 1为标题, 2为内容,3为村庄七个栏目中的哪一个"),
            ),

          // 上传村庄
          ElevatedButton(
            onPressed: () {
              createVillage();
            },
            child: const Text('创建村庄,输入1为村庄名,输入2是村庄简介'),
          ),

          // 获取推送
          ElevatedButton(
            onPressed: () {
              getPush();
            },
            child: const Text('获取推送'),
          ),

          // 下载文章
          ElevatedButton(
            onPressed: () {
              downloadArticle(6);
            },
            child: const Text('下载文章'),
          ),

          // 收藏文章
          ElevatedButton(
            onPressed: () {
              collectArticle(1);
            },
            child: const Text('收藏文章'),
          ),

          // 移除收藏
          ElevatedButton(
            onPressed: () {
              removeCollected(1);
            },
            child: const Text('移除收藏文章'),
          ),

          // 所有收藏
          ElevatedButton(
            onPressed: () {
              getCollectedList();
            },
            child: const Text('查询用户所有收藏'),
          ),

          // 添加礼品
          ElevatedButton(
            onPressed: () {
              addGift();
            },
            child: const Text('添加礼品'),
          ),

          // 增加积分
          ElevatedButton(
            onPressed: () {
              AppNetworkRequest.addCredit(10);
            },
            child: const Text('增加积分'),
          ),

          // 删除账户
          ElevatedButton(
            onPressed: () {
              deleteAccount(int.parse(firstCtrl.text));
            },
            child: const Text('删除账户，输入1为账户id'),
          ),
        ],
      ),
    );
  }

  // 选择图片
  myPickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image;
      });
    }
  }

  // 上传图片
  uploadImage(TextEditingController controller, String type) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      "id": type == 'user' ? AppData().currUserID : controller.text,
      "file": await MultipartFile.fromFile(imageFile!.path),
      'type': type,
      'flag': 'image',
    });
    Response response =
        await dio.post(AppNetworkRequest.uploadImageURL, data: formData);
    my_get.Get.snackbar(
      response.data["message"],
      response.data["data"].toString(),
    );
  }

  // 上传文章
  uploadArticle() async {
    Dio dio = Dio();
    Response response;
    FormData formData = FormData.fromMap({
      "id": AppData().currUserID,
      "file": secondCtrl.text,
      'type': 'countryside',
      'title': firstCtrl.text,
      'tag': thirdCtrl.text,
    });
    response =
        await dio.post(AppNetworkRequest.uploadArticleURL, data: formData);
    // 输出
    my_get.Get.snackbar(
      response.data["message"],
      response.data["data"].toString(),
    );
  }

  // 下载图片
  downloadImage(TextEditingController controller) async {
    Dio dio = Dio();
    Response response = await dio.get(
      "http://120.78.147.187:80/download_image/",
      queryParameters: {
        "id": int.parse(controller.text),
        'type': 'article',
      },
    );
    print(response.data);
    downImageURL = AppNetworkRequest.baseURL + response.data['data']['url'];
    print(downImageURL);
    setState(() {
      ;
    });
  }

  // 上传村庄
  createVillage() async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'name': firstCtrl.text,
      'file': secondCtrl.text,
      'position': '位于${firstCtrl.text}',
      'steam': 100,
      'distance': '5',
    });
    Response response = await dio.post(
      '${AppNetworkRequest.baseURL}upload_countryside/',
      data: formData,
    );
    print('Test: 上传村庄的返回: ');
    print(response.data);
  }

  // 获取推送
  getPush() async {
    Dio dio = Dio();
    Response response = await dio.get(
      AppNetworkRequest.getPushURL,
      queryParameters: {'type': 'article', 'size': 1},
    );
    print(response.data);
    downloadArticle(response.data['data']['post1']);
    setState(() {
      ;
    });
  }

  // 下载文章
  downloadArticle(int id) async {
    Dio dio = Dio();
    Response response = await dio
        .get(AppNetworkRequest.downloadArticleURL, queryParameters: {'id': id});
    print(response.data);
    if (response.data['data']['imgpath'] == null) {
      downImageURL = '${AppNetworkRequest.baseURL}images/1.jpg';
    } else {
      downImageURL =
          AppNetworkRequest.baseURL + response.data['data']['imgpath'];
    }
  }

  // 收藏文章
  collectArticle(int articleID) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'article_id': firstCtrl.text,
      'user_id': AppData().currUserID,
    });
    Response response = await dio.post(
      AppNetworkRequest.collectArticleURL,
      data: formData,
    );
    print(response.data);
  }

  // 移除收藏
  removeCollected(int articleID) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'article_id': firstCtrl.text,
      'user_id': AppData().currUserID,
    });
    Response response = await dio.post(
      AppNetworkRequest.removeCollectedURL,
      data: formData,
    );
    print(response.data);
  }

  // 获取收藏列表
  getCollectedList() async {
    Dio dio = Dio();
    Response response = await dio.get(
      AppNetworkRequest.getCollectedURL,
      queryParameters: {'id': AppData().currUserID},
    );
    print(response.data);
  }

  // 添加礼品
  addGift() async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({'name': firstCtrl.text, 'number': 1});
    Response response =
        await dio.post(AppNetworkRequest.uploadGiftURL, data: formData);
    print(response.data);
  }

  // 删除账户
  deleteAccount(int id) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({'admin_id': id});
    Response response =
        await dio.post(AppNetworkRequest.deleteUserURL, data: formData);
    print(response.data);
    my_get.Get.snackbar(response.data['message'], response.data['data']);
  }

  // 创建管理员账户

  // // 弹窗
  // _alertDialog() async {
  //   var result = await showDialog(
  //       barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text("提示信息!"),
  //           content: const Text("您确定要删除吗?"),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text("取消"),
  //               onPressed: () {
  //                 print("取消");
  //                 Navigator.pop(context, 'Cancle');
  //               },
  //             ),
  //             TextButton(
  //               child: const Text("确定"),
  //               onPressed: () {
  //                 print("确定");
  //                 Navigator.pop(context, "Ok");
  //               },
  //             )
  //           ],
  //         );
  //       });
  //   print(result);
  // }

  //
}
