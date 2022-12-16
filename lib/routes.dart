import 'package:cun_zhi_dao/home/article_details.dart';
import 'package:cun_zhi_dao/home/home.dart';
import 'package:cun_zhi_dao/home/search_details.dart';
import 'package:cun_zhi_dao/home/video_details.dart';
import 'package:cun_zhi_dao/main.dart';
import 'package:cun_zhi_dao/message/chat.dart';
import 'package:cun_zhi_dao/message/message.dart';
import 'package:cun_zhi_dao/mine/login.dart';
import 'package:cun_zhi_dao/mine/mine.dart';
import 'package:cun_zhi_dao/mine/my_collected.dart';
import 'package:cun_zhi_dao/mine/my_credits.dart';
import 'package:cun_zhi_dao/mine/register.dart';
import 'package:cun_zhi_dao/mine/upload_article.dart';
import 'package:cun_zhi_dao/test/test.dart';
import 'package:cun_zhi_dao/village/village.dart';
import 'package:cun_zhi_dao/village/village_details.dart';
import 'package:get/get.dart';

class AppPage {
  static const String root = "/";
  static const String home = "/home";
  static const String village = "/village";
  static const String message = "/message";
  static const String mine = "/mine";
  static const String myCollected = "/myCollected";
  static const String myCredits = "/myCredits";
  static const String chat = "/chat";
  static const String login = "/login";
  static const String register = "/register";
  static const String villageDetails = "/villageDetails";
  static const String uploadArticle = "/uploadArticle";
  static const String articleDetails = "/articleDetails";
  static const String videoDetails = "/videoDetails";
  static const String searchDetails = "/searchDetails";
  static const String test = "/test";

  static final routes = [
    GetPage(name: root, page: () => const AppTabs()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: village, page: () => const VillagePage()),
    GetPage(name: message, page: () => const MessagePage()),
    GetPage(name: mine, page: () => const MinePage()),
    GetPage(name: myCollected, page: () => const MyCollected()),
    GetPage(name: myCredits, page: () => const MyCredits()),
    GetPage(name: chat, page: () => const ChatPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: villageDetails, page: () => const VillageDetailsPage()),
    GetPage(name: uploadArticle, page: () => const UploadArticlePage()),
    GetPage(name: videoDetails, page: () => const VideoDetails()),
    GetPage(name: articleDetails, page: () => const ArticleDetailsPage()),
    GetPage(name: searchDetails, page: () => const SearchDetails()),
    GetPage(name: test, page: () => const TestPage()),
  ];
}
