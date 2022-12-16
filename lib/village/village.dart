import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/bean/bean_push.dart';
import 'package:cun_zhi_dao/bean/bean_village.dart';
import 'package:cun_zhi_dao/custom_widgets/search_bar.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VillagePage extends StatefulWidget {
  const VillagePage({super.key});

  @override
  State<VillagePage> createState() => _VillagePageState();
}

class _VillagePageState extends State<VillagePage> {
  int id = 1;
  String name = '福州大学村';

  int villageCount = 3;
  List<VillageBean> _list = [];
  TextEditingController searchController = TextEditingController();
  bool isCollected = false;

  @override
  void initState() {
    super.initState();
    refreshVillage();
  }

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() {});

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "村庄",
          style: TextStyle(color: AppTheme.appBarTitle),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: myBody(),
    );
  }

  myBody() {
    return RefreshIndicator(
      color: AppTheme.appBarBackground,
      onRefresh: () async {
        refreshVillage();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        itemCount: _list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBar(searchController: searchController),
                const SizedBox(height: 20),
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1 / 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      IconNavigation(
                        villageID: id,
                        lable: "文化风俗",
                        imagePath: "assets/images/culture.png",
                      ),
                      IconNavigation(
                        villageID: id,
                        lable: "风景",
                        imagePath: "assets/images/scenery.png",
                      ),
                      IconNavigation(
                        villageID: id,
                        lable: "乡村活动",
                        imagePath: "assets/images/activities.png",
                      ),
                      IconNavigation(
                        villageID: id,
                        lable: "美食",
                        imagePath: "assets/images/food.png",
                      ),
                      IconNavigation(
                        villageID: id,
                        lable: "旅游路线",
                        imagePath: "assets/images/route.png",
                      ),
                      IconNavigation(
                        villageID: id,
                        lable: "地理特征",
                        imagePath: "assets/images/environment.png",
                      ),
                      IconNavigation(
                        villageID: id,
                        lable: "历史背景",
                        imagePath: "assets/images/history.png",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "推荐地点",
                  style: TextStyle(
                      color: AppTheme.messageSelfBubble, fontSize: 25),
                ),
              ],
            );
          } else {
            return getRecommendCard(
              _list[index - 1].imgpath,
              _list[index - 1].name,
              _list[index - 1].id,
              _list[index - 1].article,
            );
          }
        },
      ),
    );
  }

  // 刷新村庄推送
  void refreshVillage() async {
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(AppNetworkRequest.getPushURL,
        queryParameters: {'size': villageCount, 'type': 'countryside'});
    print(response.data);

    _list = [];
    PushBean bean = PushBean.fromMap(response.data['data']);
    bean.pushList.forEach((element) async {
      print('currVillageID: $element');
      my_dio.Response villageRes = await dio.get(
        AppNetworkRequest.downloadVillageURL,
        queryParameters: {'id': element},
      );
      print(villageRes.data);
      _list.add(VillageBean.fromMap(villageRes.data['data']));
      setState(() {});
    });
  }
}

/// 引用搜索框
Widget getSearchBarUI() {
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
    child: Row(
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/images/logo_4.png")),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {
                // FocusScope.of(context).requestFocus(FocusNode());
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                // child: Icon(Icons.phone, size: 20, color: Colors.red),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20, height: 50),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 4, bottom: 4),
                child: TextField(
                  onChanged: (String txt) {},
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '搜索...',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// 村庄图标导航
class IconNavigation extends StatelessWidget {
  int villageID;
  String lable, imagePath;
  IconNavigation(
      {super.key,
      required this.villageID,
      required this.lable,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppPage.articleDetails,
          arguments: {"villageID": villageID, 'tag': lable},
        );
      },
      child: Column(
        children: [
          const SizedBox(height: 10),
          Image(image: AssetImage(imagePath), fit: BoxFit.cover),
          Text(lable),
        ],
      ),
    );
  }
}

// 推荐地点卡片
getRecommendCard(String imageURL, String name, int id, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: GestureDetector(
      onTap: () {
        Get.toNamed(AppPage.villageDetails, arguments: {
          "imageURL": imageURL,
          'name': name,
          'id': id,
          'text': text,
        });
      },
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imageURL),
                  filterQuality: FilterQuality.low,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(name, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 15),
                const Text(
                  '20.0 km',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  '福建省南平市',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
