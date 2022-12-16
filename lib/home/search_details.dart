import 'package:cun_zhi_dao/app_theme.dart';
import 'package:flutter/material.dart';

class SearchDetails extends StatefulWidget {
  const SearchDetails({super.key});

  @override
  State<SearchDetails> createState() => _SearchDetailsState();
}

class _SearchDetailsState extends State<SearchDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('搜索结果', style: TextStyle(color: AppTheme.appBarTitle)),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: myBody(),
    );
  }

  myBody() {}
}
