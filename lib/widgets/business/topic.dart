// 帖子列表item

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:iv2ex/model/member.dart';
import 'package:iv2ex/model/topic.dart';
import 'package:iv2ex/utils/utils.dart';
import 'package:iv2ex/widgets/system/NetImage.dart';
import 'package:iv2ex/widgets/system/skeleton/skeleton.dart';
import 'package:iv2ex/widgets/system/spacer/spacer.dart';

class Topic extends StatefulWidget {
  final TopicModel topic;
  Topic(this.topic);
  @override
  TopicState createState() => TopicState();

  static Widget skeleton(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Skeleton.headPic(context, width: 36, height: 36),
              margin: EdgeInsets.only(right: 10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton.line(context, height: 20),
                  Skeleton.line(context, width: double.infinity),
                  Skeleton.line(context,
                      width: DesignSize.of(context).calc(200)),
                  Skeleton.line(context,
                      width: DesignSize.of(context).calc(100)),
                ],
              ),
            ),
          ],
        ));
  }
}

class TopicState extends State<Topic> {
  String get renderContent {
    var document = parse(widget.topic.content);
    return document.nodes.map((el) => el.text).toList().join("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user(widget.topic.member),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(context),
                content(),
                Row(
                  children: spacer([
                    reply(),
                    Text(
                      "${widget.topic.getlastTouched ?? ""}",
                      style: TextStyle(color: Colors.grey),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget node() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(2)),
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
        child: Text(
          widget.topic.node.title ?? "节点",
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.white),
        ));
  }

  Container content() {
    return widget.topic.content != ""
        ? Container(
            decoration: BoxDecoration(),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              renderContent ?? "~",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          )
        : Container(margin: EdgeInsets.only(bottom: 10));
  }

// 标题
  Text title(BuildContext context) {
    return Text.rich(TextSpan(
        // text: widget.topic.title ?? "~",
        style: TextStyle(
          fontSize: DesignSize.of(context).calc(16),
          fontWeight: FontWeight.bold,
        ),
        children: [
          WidgetSpan(
              child: Container(
            child: node(),
            margin: EdgeInsets.only(right: 4),
          )),
          TextSpan(text: widget.topic.title ?? "~")
        ]));
  }

  // 回复数
  Container reply() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
      margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
      child: Text(
        "回复:${widget.topic.replies ?? 0}",
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }

// 头像
  Widget user(MemberModel member) {
    var headPicWidth = DesignSize.of(context).calc(28);
    return Container(
        width: headPicWidth,
        margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Image(
                    image: NetImage(member.avatarLarge ?? ""),
                    fit: BoxFit.cover),
              ),
            ),
            Text(member.username ?? "未知用户",
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: TextStyle(fontSize: DesignSize.of(context).calc(12))),
          ],
        ));
  }
}
