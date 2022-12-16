import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhotoSelectState();
  }
}

class _PhotoSelectState extends State<PhotoSelect> {
  List<File> imgArray = [];
  final ImagePicker _picker = ImagePicker();
  Future pickImage({required ImageSource type}) async {
    Navigator.pop(context);
    var image = await _picker.pickImage(source: type);
    setState(() {
      imgArray.add(File(image!.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = (ModalRoute.of(context)!.settings.arguments as Map)['desc'];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 20,
            child: SizedBox(
              width: 50,
              height: 50,
              child: ClipOval(
                child: Container(
                  color: Colors.blue,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: _showSheetAction,
                    icon: const Icon(
                      Icons.photo_camera,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: imgArray.isNotEmpty
                ? Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: imgArray
                        .map((item) => _imageItem(imagePth: item))
                        .toList(),
                  )
                : Text('您还没有添加图片'),
          ),
        ],
      ),
    );
  }

  Widget _imageItem({required File imagePth}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.file(
            imagePth,
            width: 110,
            height: 70,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: () {
              //print('点击了删除');
              // List<File> cacheList = [];
              // cacheList.addAll(imgArray);
              // cacheList.remove(imagePth);
              setState(() {
                imgArray.remove(imagePth);
              });
            },
            child: ClipOval(
              child: Container(
                color: Colors.white.withOpacity(0.7),
                width: 20,
                height: 20,
                child: const Icon(
                  Icons.close,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showSheetAction() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 120,
        child: Column(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  pickImage(type: ImageSource.camera);
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity - 20,
                  child: Center(child: Text('拍照')),
                ),
              ),
            ),
            const Divider(height: 5),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  pickImage(type: ImageSource.gallery);
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity - 20,
                  color: Colors.white24,
                  child: const Center(child: Text('从相册选取')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
