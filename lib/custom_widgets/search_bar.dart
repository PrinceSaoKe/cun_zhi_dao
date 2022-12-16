import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:cun_zhi_dao/routes.dart';
import 'package:dio/dio.dart' as my_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 自制搜索框
class SearchBar extends StatelessWidget {
  TextEditingController searchController;
  SearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.lightGreen,
              ),
            ),
          ),
          Expanded(
            flex: 18,
            child: TextField(
              controller: searchController,
              cursorColor: AppTheme.appBarBackground,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '搜索...',
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                // color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    searchArticle(searchController);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.appBarBackground,
                    fixedSize: const Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.67),
                    ),
                  ),
                  child: const Text('搜索'),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  // 搜索
  searchArticle(TextEditingController searchController) async {
    print(AppNetworkRequest.searchArticleURL);
    my_dio.Dio dio = my_dio.Dio();
    my_dio.Response response = await dio.get(
      AppNetworkRequest.searchArticleURL,
      queryParameters: {
        'search': searchController.text,
        'size': 3,
        'page': '1',
      },
    );
    print(response.data);
    Get.toNamed(AppPage.searchDetails);
  }
}

// 引用搜索框
Widget getSearchBarUI() {
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 8),
    child: Row(
      children: <Widget>[
        const SizedBox(width: 20),
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
                    blurRadius: 8.0,
                  ),
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
        const SizedBox(width: 10),
      ],
    ),
  );
}
