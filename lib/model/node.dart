import 'package:iv2ex/config.dart';
import 'package:iv2ex/utils/utils.dart';

class NodeModal {
  String name;
  String avatarLarge;
  String avatarNormal;
  String avatarMini;
  String title;
  String url;
  int topics;
  String footer;
  String header;
  String titleAlternative;
  int stars;
  List<dynamic> aliases;
  bool root;
  int id;
  String parentNodeName;

  NodeModal.fromJSON(Map<String, dynamic> json)
      : name = json["name"],
        avatarLarge = json["avatarLarge"],
        avatarNormal = json["avatar_normal"],
        avatarMini = json["avatar_mini"],
        title = json["title"],
        url = json["url"],
        topics = json["topics"],
        footer = json["footer"],
        header = json["header"],
        titleAlternative = json["title_alternative"],
        stars = json["stars"],
        aliases = json["aliases"],
        root = json["root"],
        id = json["id"],
        parentNodeName = json["parent_node_name"];

  String get getavatarNormal {
    return replaceImageUrl(this.avatarNormal, baseURL);
  }
}
