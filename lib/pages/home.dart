import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iv2ex/model/member.dart';
import 'package:iv2ex/model/topic.dart';
import 'package:iv2ex/pages/detail.dart';
import 'package:iv2ex/pages/search.dart';
import 'package:iv2ex/server/v2ex.dart';
import 'package:iv2ex/utils/iconFont.dart';
import 'package:iv2ex/widgets/business/topic.dart';
import 'package:iv2ex/widgets/system/list/list.dart';

import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

class Tabs {
  String name;
  String url;
  Tabs(this.name, this.url);
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  MemberModel userInfo = MemberModel();
  Map<String, List<TopicModel>> topics = Map<String, List<TopicModel>>();
  TabController _tabController;
  List<Tabs> tabs = [
    Tabs("最新", "/api/topics/latest.json"),
    Tabs("热门", "/api/topics/hot.json"),
    Tabs("apple", "/api/topics/show.json?node_name=apple"),
    Tabs("酷工作", "/api/topics/show.json?node_name=jobs"),
    Tabs("创意", "/api/topics/show.json?node_name=create")
  ];
  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 0)
          ..addListener(() {
            if (topics[_tabController.index.toString()] == null) {
              load();
            }
          });
    // 初始化
    load();
  }

  Future load({int index}) async {
    // await V2EXAPI.instance.get("/api/members/show.json",
    //     data: {"username": "suke971219"}).then((value) {
    //   var jsonStr = value as String;
    //   try {
    //     Map user = json.decode(jsonStr);
    //     setState(() {
    //       userInfo = new MemberModel.fromJSON(user);
    //     });
    //   } catch (err) {}
    // });
    if (index == null) {
      index = _tabController.index;
    }

    await V2EXAPI.instance.get(tabs[index].url).then((value) {
      try {
        List<dynamic> jsonArr = value.data;
        setState(() {
          // 解析
          topics[index.toString()] = jsonArr
              .map((value) {
                return new TopicModel.fromJSON(value);
              })
              .cast<TopicModel>()
              .toList();
        });
      } catch (err) {
        print(err);
      }
    });
  }

  // 跳转到详情页面
  void navigatorDetail() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return Material(
          child: Column(
        children: [
          safeAreaTop(context),
          Text("hello"),
        ],
      ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        child: Column(
          children: [
            // navbar(context, title: "V2EX"),
            Container(
              child: safeAreaTop(context),
              decoration: BoxDecoration(color: Colors.white),
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    child: Text("V2EX",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Expanded(child: tabbar()),
                  Container(
                    child: TouchView(
                      onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return Search();
                        }));
                      },
                      child: Icon(
                        IconFont.icon_search,
                        color: Colors.grey,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: tabs.asMap().entries.map((e) {
                  var i = e.key;
                  // var v = e.value;
                  return PageList(
                    load: () {
                      setState(() {
                        topics[_tabController.index.toString()] = [];
                      });
                      return load(index: i);
                    },
                    children: (topics[i.toString()] ?? [])
                        .map((e) => TouchView(
                            onTap: () {
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context) {
                                return TopicDetail(topic: e);
                              }));
                            },
                            child: Topic(e)))
                        .toList(),
                    skeleton: Topic.skeleton(context),
                  );
                }).toList(),
                controller: _tabController,
              ),
            ),
            // body
          ],
        ),
      ),
    );
  }

  TabBar tabbar() {
    return TabBar(
      isScrollable: true,
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.blue,
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      tabs: tabs
          .map((t) => Tab(
                text: t.name,
              ))
          .toList(),
      controller: _tabController,
    );
  }
}
