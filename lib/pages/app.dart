import 'package:flutter/material.dart';
import 'package:iv2ex/pages/home.dart';
import 'package:iv2ex/pages/member.dart';
import 'package:iv2ex/pages/message.dart';
import 'package:iv2ex/pages/node.dart';
import 'package:iv2ex/utils/iconFont.dart';
import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<AppPage> pages = [
    AppPage(page: HomePage(), text: "V2EX", icon: IconFont.icon_home),
    AppPage(page: Node(), text: "节点", icon: IconFont.icon_voiceprint),
    AppPage(page: Message(), text: "消息", icon: IconFont.icon_message),
    AppPage(page: Member(), text: "我的", icon: IconFont.icon_nickname)
  ];

  int _pageIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(
              children: pages.map((v) => v.page).toList(),
              index: _pageIndex,
            ),
          ),
          tabbar(),
          safeAreaBottom(context)
        ],
      ),
    );
  }

  Container tabbar() {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: pages.asMap().entries.map(
            (e) {
              var index = e.key;
              var val = e.value;
              var selected = index == _pageIndex;
              var color = selected ? Colors.blue : Colors.grey;
              return TouchView(
                onTap: () {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                  child: Column(
                    children: [
                      Icon(val.icon, color: color),
                      Text(
                        val.text ?? "-",
                        style: TextStyle(color: color),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList()),
    );
  }
}

class AppPage {
  Widget page;
  IconData icon;
  String text;
  AppPage({@required this.page, @required this.text, this.icon});
}
