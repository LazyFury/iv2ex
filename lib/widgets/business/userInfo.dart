import 'package:flutter/material.dart';
import 'package:iv2ex/model/member.dart';

import 'package:iv2ex/utils/utils.dart';

class UserInfo extends StatefulWidget {
  final MemberModel info;
  UserInfo({this.info});

  @override
  UserInfoState createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    var headPicWidth = DesignSize.of(context).calc(80);

    return Material(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: headPicWidth,
                  height: headPicWidth,
                  padding: EdgeInsets.all(10),
                  child: widget.info.avatarLarge != null
                      ? Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.info.avatarLarge),
                        )
                      : null,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.info.username ?? "用户名～",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("第1号会员",
                        style: TextStyle(fontWeight: FontWeight.w300)),
                    Text(
                      "github:${widget.info.github}",
                    ),
                    Text("website:${widget.info.website}"),
                    Text("twitter:${widget.info.twitter}"),
                  ],
                ),
              ],
            ),
            Text("用户于 ${widget.info.regBy} 加入 V2EX",
                style: TextStyle(fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
