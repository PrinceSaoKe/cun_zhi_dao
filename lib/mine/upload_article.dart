import 'dart:io';

import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/custom_widgets/dialog.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadArticlePage extends StatefulWidget {
  const UploadArticlePage({super.key});

  @override
  State<UploadArticlePage> createState() => _UploadArticlePageState();
}

class _UploadArticlePageState extends State<UploadArticlePage> {
  XFile? imageFile;
  List<XFile> imageList = [];
  int articleID = -1;
  String fileType = 'image';
  TextEditingController articleController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "编辑文章",
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(30, 19, 30, 19),
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(21, 14, 21, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 上传封面
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          color: AppTheme.messageSelfBubble,
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  '添加图片',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  myPickImage();
                                  fileType = 'image';
                                  Get.back();
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.video_call,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  '添加视频',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  myPickVideo();
                                  fileType = 'video';
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageFile == null
                          ? const Icon(Icons.add, size: 30, color: Colors.grey)
                          : (fileType == 'image'
                              ? Image.file(
                                  File(imageFile!.path),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/video.png',
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),

                  // 标题输入框
                  TextField(
                    controller: titleController,
                    cursorColor: AppTheme.appBarBackground,
                    decoration: const InputDecoration(
                      hintText: '添加标题',
                      hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.appBarBackground,
                        ),
                      ),
                    ),
                  ),

                  // 正文输入框
                  TextField(
                    controller: articleController,
                    minLines: 10,
                    maxLines: 20,
                    cursorColor: AppTheme.appBarBackground,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '添加文字',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 提交投稿按钮
          ElevatedButton(
            onPressed: () {
              uploadArticle();
              // uploadImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonColor,
              fixedSize: const Size(295, 59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "提交投稿",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),

          const SizedBox(height: 16),

          // 稿件查询按钮
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonColor,
              fixedSize: const Size(295, 59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "稿件状态",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  uploadArticle() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response;
    // 用FormData格式
    my_dio.FormData formData = my_dio.FormData.fromMap(
      {
        "id": AppData().currUserID,
        'title': titleController.text,
        "file": articleController.text,
        'tag': fileType,
        'type': 'user',
      },
    );
    response =
        await dio.post(AppNetworkRequest.uploadArticleURL, data: formData);
    articleID = response.data['data']['id'];
    uploadImage();

    // 输出
    AlertDialog(
      title: const Text('提交成功！'),
      content: const Text('等待管理员审核'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('确定'),
        ),
      ],
    );
  }

  myPickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image;
        imageList.add(image);
      });
    }
  }

  myPickVideo() async {
    XFile? image = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image;
        imageList.add(image);
      });
    }
  }

  uploadImage() async {
    if (articleID == -1) {
      Get.snackbar("警告", "请先上传文章, 再上传图片!");
      return;
    }
    my_dio.Dio dio = my_dio.Dio();
    my_dio.FormData formData = my_dio.FormData.fromMap({
      "id": articleID,
      "file": await my_dio.MultipartFile.fromFile(imageFile!.path),
      "type": "article",
      "flag": fileType == 'image' ? 'image' : 'video',
    });
    my_dio.Response response =
        await dio.post(AppNetworkRequest.uploadImageURL, data: formData);
    print(response.data);
    // Get.snackbar(
    //   response.data["message"],
    //   response.data["data"].toString(),
    // );

    alertDialog(context, title: '成功！', text: '您的作品已上传，等待管理员审核中...');

    // Test
    save(response.data['data']['url']);
  }

  save(String url) {
    AppData().box.write('url', url);
  }
}
