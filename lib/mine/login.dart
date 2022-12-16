import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    passwordController.addListener(() {});
    usernameController.addListener(() {});

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 70,
            height: 50,
            padding: const EdgeInsets.only(right: 10),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppPage.register);
                },
                child: const Text("注册", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.appBarBackground,
      body: ListView(
        // 取消ListView滑到尽头的特效
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const LoginImage(),
                const SizedBox(height: 30),
                LoginTextField(
                  controller: usernameController,
                  hintText: "请输入用户名...",
                ),
                const SizedBox(height: 30),
                LoginTextField(
                  controller: passwordController,
                  hintText: "请输入密码...",
                  hideText: true,
                ),
                const SizedBox(height: 40),
                LoginButton(
                  passwordController: passwordController,
                  usernameController: usernameController,
                ),
                const SizedBox(height: 100),
                const OtherLogin(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 登录页面头像
class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(AppData().currUserAvatar),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [BoxShadow(blurRadius: 10)],
        ),
      ),
    );
  }
}

// 登录输入框
class LoginTextField extends StatelessWidget {
  // 在输入框尾部的组件
  Widget? suffix;
  TextEditingController controller;
  String? hintText;
  bool hideText;
  TextInputType? inputType;
  LoginTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.suffix,
    this.hideText = false,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 270,
      child: TextField(
        controller: controller,
        // 输入密码模式
        obscureText: hideText,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.circle,
            color: Colors.white,
            size: 20,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: const TextStyle(color: Colors.white),
          suffix: suffix,
          hintText: hintText,
        ),
        cursorColor: Colors.white,
        // 输入类型
        keyboardType: inputType,
      ),
    );
  }
}

// 登录按钮
class LoginButton extends StatelessWidget {
  TextEditingController passwordController, usernameController;
  LoginButton({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        my_dio.Response response;
        my_dio.Dio dio = my_dio.Dio();
        response = await dio.get(
          AppNetworkRequest.passwordLoginURL,
          queryParameters: {
            "username": usernameController.text,
            "password": passwordController.text,
            'type': 'user',
          },
        );
        print(response.data);
        Get.defaultDialog(
          title: '登陆成功！',
          middleText:
              '用户名：${response.data['data']['username']}\n手机号：${response.data['data']['telephone']}',
          onConfirm: () {
            Get.back();
            Get.back();
          },
          confirmTextColor: Colors.black,
        );

        // 储存用户数据
        AppData appData = AppData();
        if (response.data['status'] == 200) {
          appData.box
              .write("currUserID", response.data['data']['id'].toString());
          appData.box.write("currUserName", response.data['data']['username']);
          appData.box.write("currUserTele", response.data['data']['telephone']);
          // 获取头像
          if (response.data['data']['imgpath'] == null) {
            appData.box.write(
              'currUserAvatar',
              '${AppNetworkRequest.baseURL}images/1.png',
            );
          } else {
            appData.box.write(
              'currUserAvatar',
              AppNetworkRequest.baseURL + response.data['data']['imgpath'],
            );
          }
          print(AppNetworkRequest.baseURL + response.data['data']['imgpath']);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.messageSelfBubble,
        fixedSize: const Size(250, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.67),
        ),
      ),
      child: const Text(
        "登     录",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

// 第三方登录
class OtherLogin extends StatelessWidget {
  const OtherLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 70, height: 1, color: Colors.black),
            const SizedBox(width: 20),
            const Text(
              '第三方登录',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 20),
            Container(width: 70, height: 1, color: Colors.black),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(image: AssetImage('assets/images/login_vx.png')),
            SizedBox(width: 40),
            Image(image: AssetImage('assets/images/login_qq.png')),
            SizedBox(width: 40),
            Image(image: AssetImage('assets/images/login_weibo.png')),
          ],
        ),
      ],
    );
  }
}
