import 'package:iv2ex/model/member.dart';
import 'package:iv2ex/model/node.dart';
import 'package:iv2ex/utils/time.dart';

class TopicModel {
  NodeModal node;
  MemberModel member;
  String lastReplyBy;
  int lastTouched;
  String title;
  String url;
  int created;
  String content;
  int lastModified;
  int replies;
  int id;

  TopicModel.fromJSON(Map<String, dynamic> json)
      : node = NodeModal.fromJSON(json["node"]),
        member = MemberModel.fromJSON(json["member"]),
        lastReplyBy = json["last_reply_by"],
        lastTouched = json["last_touched"],
        title = json["title"],
        url = json["url"],
        created = json["created"],
        content = json["content_rendered"],
        lastModified = json["last_modified"],
        replies = json["replies"],
        id = json["id"];

  String get getlastTouched {
    var date = new DateTime.fromMillisecondsSinceEpoch(this.lastTouched * 1000);
    return RelativeDateFormat.format(date);
  }

  String get createdTime {
    var date = new DateTime.fromMillisecondsSinceEpoch(this.created * 1000);
    return RelativeDateFormat.format(date);
  }
}
