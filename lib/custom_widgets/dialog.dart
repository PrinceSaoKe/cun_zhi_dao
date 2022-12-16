import 'package:cun_zhi_dao/app_theme.dart';
import 'package:flutter/material.dart';

alertDialog(BuildContext context,
    {String title = '标题', String text = '内容', bool needCancle = false}) async {
  await showDialog(
      barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            if (needCancle)
              TextButton(
                child: const Text(
                  "取消",
                  style: TextStyle(color: AppTheme.appBarBackground),
                ),
                onPressed: () {
                  Navigator.pop(context, 'Cancle');
                },
              ),
            TextButton(
              child: const Text(
                "确定",
                style: TextStyle(color: AppTheme.appBarBackground),
              ),
              onPressed: () {
                Navigator.pop(context, "Ok");
              },
            ),
          ],
        );
      });
}
