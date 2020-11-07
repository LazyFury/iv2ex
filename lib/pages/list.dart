import 'package:flutter/material.dart';
import 'package:iv2ex/model/node.dart';
import 'package:iv2ex/model/topic.dart';
import 'package:iv2ex/pages/detail.dart';
import 'package:iv2ex/server/v2ex.dart';
import 'package:iv2ex/widgets/business/topic.dart';
import 'package:iv2ex/widgets/system/list/list.dart';
import 'package:iv2ex/widgets/system/navbar.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

class TopicList extends StatefulWidget {
  final NodeModal node;
  TopicList({Key key, @required this.node}) : super();
  @override
  State<StatefulWidget> createState() {
    return TopicListState();
  }
}

class TopicListState extends State<TopicList> {
  List<TopicModel> topics = [];

  load() async {
    await V2EXAPI.instance
        .get("/api/topics/show.json?node_name=" + widget.node.name)
        .then((value) {
      try {
        setState(() {
          topics = (value.data as List<dynamic>)
              .map((e) => TopicModel.fromJSON(e as Map<String, dynamic>))
              .toList();
        });
      } catch (err) {}
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          navbar(context, title: widget.node.title ?? "节点"),
          Expanded(
            child: PageList(
              children: topics
                  .map((e) => TouchView(
                      onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return TopicDetail(topic: e);
                        }));
                      },
                      child: Topic(e)))
                  .toList(),
              load: () async {
                return load();
              },
              skeleton: Topic.skeleton(context),
            ),
          ),
        ],
      ),
    );
  }
}
