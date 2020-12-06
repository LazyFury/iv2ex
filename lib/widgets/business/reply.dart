import 'package:flutter/material.dart';
import 'package:iv2ex/model/reply.dart';
import 'package:iv2ex/model/topic.dart';
import 'package:iv2ex/utils/iconFont.dart';
import 'package:iv2ex/widgets/system/renderContent.dart';
import 'package:iv2ex/widgets/system/NetImage.dart';
import 'package:iv2ex/widgets/system/skeleton/skeleton.dart';

class Reply extends StatefulWidget {
  final ReplyModel reply;
  final TopicModel topic;
  final int talkNum;
  Reply({Key key, this.reply, this.topic, this.talkNum}) : super();
  @override
  State<StatefulWidget> createState() => ReplyState();

  static Widget skeleton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: Skeleton.headPic(context, width: 32, height: 32)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton.line(context, width: double.infinity),
              Skeleton.line(context, width: 100),
              Skeleton.line(context, width: 140),
              Divider()
            ],
          ))
        ],
      ),
    );
  }
}

class ReplyState extends State<Reply> {
  @override
  Widget build(BuildContext context) {
    return reply(widget.reply);
  }

  Container reply(ReplyModel reply) => Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 32,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image(
                  image: NetImage(reply.member.avatarLarge),
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    style: TextStyle(color: Colors.blue),
                    text: reply.member.username == widget.topic.member.username
                        ? "楼主："
                        : (reply.member.id == 1 ? "站长：" : ""),
                  ),
                  TextSpan(
                    text: reply.member.username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  WidgetSpan(
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            reply.getCreatedTime,
                            style: TextStyle(color: Colors.grey),
                          )))
                ])),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    child: renderContent(context, widget.reply.content)),
                Divider(),
                Container(
                  child: Wrap(children: [
                    Container(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(IconFont.icon_message),
                          Text((widget.talkNum ?? 0).toString())
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Row(
                        children: [Icon(IconFont.icon_like), Text("发送感谢")],
                      ),
                    )
                  ]),
                )
                // Divider()
              ],
            ),
          ),
        ],
      ));
}
