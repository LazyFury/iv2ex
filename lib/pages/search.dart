import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:iv2ex/widgets/system/navbar.dart';
import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';

class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          safeAreaTop(context),
          Container(
            height: 50,
            child: Row(
              children: [getBackButton(context)],
            ),
          ),
          Expanded(
              child: EasyRefresh(
                  child: Column(
            children: [Text("search")],
          )))
        ],
      ),
    );
  }
}
