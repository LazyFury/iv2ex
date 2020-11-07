import 'package:iv2ex/model/member.dart';
import 'package:iv2ex/utils/time.dart';

class ReplyModel {
  MemberModel member;
  int created;
  int topicId;
  String content;
  int lastModified;
  int memberId;
  int id;

  ReplyModel.fromJSON(Map<String, dynamic> json)
      : member = MemberModel.fromJSON(json['member']),
        created = json["created"],
        topicId = json["topic_id"],
        content = json["content"],
        lastModified = json["last_modified"],
        memberId = json["member_id"],
        id = json['id'];

  String get getCreatedTime {
    var date = new DateTime.fromMillisecondsSinceEpoch(created * 1000);
    return RelativeDateFormat.format(date);
  }
}
