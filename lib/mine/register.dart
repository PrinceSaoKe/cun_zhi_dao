import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool agreeCheck = false;
  TextEditingController teleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController userCodeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  Get.toNamed(AppPage.login);
                },
                child: const Text("登录", style: TextStyle(fontSize: 20)),
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
                const SizedBox(height: 10),
                const LoginImage(),
                const SizedBox(height: 30),
                LoginTextField(
                  controller: teleController,
                  inputType: TextInputType.number,
                  hintText: "请输入手机号...",
                  suffix: YanZhengMaButton(
                    teleController: teleController,
                  ),
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: usernameController,
                  hintText: "请输入用户名...",
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: passwordController,
                  hintText: "请输入密码...",
                  hideText: true,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: password2Controller,
                  hintText: "请再次输入密码...",
                  hideText: true,
                ),
                const SizedBox(height: 20),
                LoginTextField(
                  controller: userCodeController,
                  inputType: TextInputType.number,
                  hintText: "请输入验证码",
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 45),
                    Checkbox(
                      value: agreeCheck,
                      activeColor: AppTheme.messageSelfBubble,
                      checkColor: Colors.white,
                      shape: const CircleBorder(),
                      onChanged: (value) {
                        agreeCheck = !agreeCheck;
                        setState(() {});
                      },
                    ),
                    const Text(
                      '我已阅读使用条款和隐私政策',
                      style: TextStyle(
                        color: AppTheme.messageSelfBubble,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RegisterButton(
                  passwordController: passwordController,
                  password2Controller: password2Controller,
                  teleController: teleController,
                  userCodeController: userCodeController,
                  usernameController: usernameController,
                ),
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

// 获取验证码按钮
class YanZhengMaButton extends StatelessWidget {
  TextEditingController teleController;
  final String _url = AppNetworkRequest.sendPinURL;
  YanZhengMaButton({super.key, required this.teleController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        my_dio.Response response;
        my_dio.Dio dio = my_dio.Dio();
        my_dio.FormData formData = my_dio.FormData.fromMap(
          {"telephone": teleController.text},
        );
        response = await dio.post(_url, data: formData);
        Get.snackbar(
          response.data["message"].toString(),
          response.data["data"].toString(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.messageSelfBubble,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text("获取验证码"),
    );
  }
}

// 注册按钮
class RegisterButton extends StatelessWidget {
  String type;
  TextEditingController passwordController,
      password2Controller,
      teleController,
      usernameController,
      userCodeController;
  final String _url = AppNetworkRequest.registerURL;
  RegisterButton({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.password2Controller,
    this.type = "student",
    required this.teleController,
    required this.userCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        my_dio.Response response;
        my_dio.Dio dio = my_dio.Dio();
        my_dio.FormData formData = my_dio.FormData.fromMap({
          "username": usernameController.text,
          "password": passwordController.text,
          "password2": password2Controller.text,
          "type": type,
          "telephone": teleController.text,
          "user_code": userCodeController.text,
        });

        response = await dio.post(_url, data: formData);
        print(response.data);

        // 显示对话框
        String message = response.data['message'];
        Get.defaultDialog(
          title: '',
          middleText: message,
          onConfirm: () {
            Get.back();
          },
          confirmTextColor: Colors.black,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.messageSelfBubble,
        fixedSize: const Size(250, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.67),
        ),
      ),
      child: const Text(
        "注     册",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
