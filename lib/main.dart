import 'package:cun_zhi_dao/app_data.dart';
import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/home/home.dart';
import 'package:cun_zhi_dao/message/message.dart';
import 'package:cun_zhi_dao/mine/mine.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:cun_zhi_dao/village/village.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppData().checkData();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.appBarBackground,
        // 修改ListView过度滚动的颜色
        colorScheme:
            const ColorScheme.light(secondary: AppTheme.appBarBackground),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.appBarBackground,
          ),
        ),
      ),
      initialRoute: "/",
      getPages: AppPage.routes,
    );
  }
}

class AppTabs extends StatefulWidget {
  const AppTabs({super.key});

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const VillagePage(),
    const MessagePage(),
    const MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: AppTheme.messageSelfBubble,
        showUnselectedLabels: true,
        items: const [
          // TODO 需要改icon
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
            backgroundColor: AppTheme.appBarBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.holiday_village_rounded),
            label: "村庄",
            backgroundColor: AppTheme.appBarBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "消息",
            backgroundColor: AppTheme.appBarBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "我的",
            backgroundColor: AppTheme.appBarBackground,
          ),
        ],
      ),
    );
  }
}
