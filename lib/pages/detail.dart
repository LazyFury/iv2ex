import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:iv2ex/model/reply.dart';
import 'package:iv2ex/model/topic.dart';
import 'package:iv2ex/server/v2ex.dart';
import 'package:iv2ex/widgets/system/renderContent.dart';
import 'package:iv2ex/widgets/business/reply.dart';
import 'package:iv2ex/widgets/system/NetImage.dart';
import 'package:iv2ex/widgets/system/list/empty.dart';
import 'package:iv2ex/widgets/system/navbar.dart';
import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';
import 'package:iv2ex/widgets/system/spacer/spacer.dart';

class TopicDetail extends StatefulWidget {
  final TopicModel topic;
  TopicDetail({Key key, this.topic}) : super();
  @override
  TopicDetailState createState() => TopicDetailState();
}

class TopicDetailState extends State<TopicDetail> {
  List<ReplyModel> replies = [];
  int selected = -1;
  bool firstLoad = true;

  CancelToken token = CancelToken();
  getReplys() async {
    await V2EXAPI.instance
        .get("/api/replies/show.json?topic_id=" + widget.topic.id.toString(),
            cancelToken: token)
        .then((value) {
      try {
        List<dynamic> _json = value.data;
        setState(() {
          replies = _json
              .map((e) => ReplyModel.fromJSON(e as Map<String, dynamic>))
              .toList()
                ..sort((a, b) => b.created.compareTo(a.created));
        });
      } catch (err) {}
    }).then((value) {
      setState(() {
        firstLoad = false;
      });
    }).catchError((err) {
      if (CancelToken.isCancel(err)) {
        print("cancel");
      }
    });
  }

  List<ReplyModel> get talks {
    if (replies.length <= 0) return [];
    if (selected < 0) return [];
    var el = replies[selected] ?? null;
    if (el == null) return [];
    return replies.where((element) {
      return RegExp('(!${element.member.username})?(${el.member.username})')
          .hasMatch(element.content);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getReplys();
  }

  @override
  void dispose() {
    token.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(children: [
        navbar(context, title: widget.topic.title),
        Expanded(
            child: EasyRefresh.custom(
                onRefresh: () async {
                  setState(() {
                    firstLoad = true;
                    replies = [];
                  });
                  getReplys();
                },
                slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                return [
                  topic(),
                  count(),
                  Divider(),
                ][i];
              }, childCount: 3)),
              (replies.length > 0)
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, i) {
                      return Reply(
                        reply: replies[i],
                        topic: widget.topic,
                        talkNum: replies.where((element) {
                          return RegExp(
                                  '(!${element.member.username})?(${replies[i].member.username})')
                              .hasMatch(element.content);
                        }).length,
                      );
                    }, childCount: replies.length))
                  : (firstLoad
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            return Reply.skeleton(context);
                          }, childCount: 3),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                          return [Empty()][i];
                        }, childCount: 1)))
            ])),
        safeAreaBottom(context)
      ]),
    ));
  }

  Container count() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [Text("共 ${replies.length ?? 0} 条回复")],
      ),
    );
  }

  Container topic() {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.topic.title ?? "",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            ...spacer([
                              Text(
                                "楼主：" + widget.topic.member.username,
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                widget.topic.createdTime,
                                style: TextStyle(color: Colors.grey),
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: NetImage(widget.topic.member.avatarLarge),
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: renderContent(context, widget.topic.content)),
            Container(
              child: Text(
                widget.topic.node.title,
                style: TextStyle(color: Colors.white),
              ),
              margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
              padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(2)),
            )
          ],
        ));
  }
}
