import 'package:intl/intl.dart';

class MemberModel {
  String username;
  String age;
  String website;
  String github;
  String avatarLarge;
  String twitter;
  int created;
  String location;
  int id;
  MemberModel();

  MemberModel.fromJSON(Map<String, dynamic> json)
      : username = json["username"],
        age = json["age"],
        website = json["website"],
        github = json["github"],
        avatarLarge = json["avatar_large"],
        twitter = json["twitter"],
        created = json["created"],
        location = json["location"],
        id = json['id'];

  // 注册时间格式化
  String get regBy {
    var date = DateTime.fromMillisecondsSinceEpoch((this.created ?? 0) * 1000);
    var format = DateFormat("yyyy-MM-DD HH:mm:ss");
    return format.format(date);
  }
}
