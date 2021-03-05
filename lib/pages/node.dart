import 'package:flutter/material.dart';
import 'package:iv2ex/model/node.dart';
import 'package:iv2ex/pages/list.dart';
import 'package:iv2ex/server/v2ex.dart';
import 'package:iv2ex/utils/utils.dart';
import 'package:iv2ex/widgets/system/NetImage.dart';
import 'package:iv2ex/widgets/system/navbar.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

class Node extends StatefulWidget {
  @override
  State<Node> createState() => NodeState();
}

class NodeState extends State<Node> {
  List<NodeModal> nodes = List<NodeModal>.empty();

  List<NodeModal> rootNode = [
    NodeModal.fromJSON({"name": "all", "title": "全部节点"}),
    NodeModal.fromJSON({"name": "v2ex", "title": "V2EX"}),
    NodeModal.fromJSON({"name": "apple", "title": "apple"}),
    NodeModal.fromJSON({"name": "life", "title": "生活"}),
    NodeModal.fromJSON({"name": "programmer", "title": "程序员"})
  ];

  String _currentRootName = "all";

  List<NodeModal> secNode(String rootName) {
    if (rootName == "all") {
      return nodes;
    }
    return nodes
        .where((element) => element.parentNodeName == rootName)
        .toList();
  }

  Future load() async {
    await V2EXAPI.instance.get("/api/nodes/all.json").then((value) {
      try {
        List<dynamic> _json = value.data;
        setState(() {
          nodes = _json
              .map((e) {
                return NodeModal.fromJSON(e as Map<String, dynamic>);
              })
              .cast<NodeModal>()
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
          // safeAreaTop(context),
          navbar(context, title: "节点"),
          Expanded(
            child: Row(
              children: [
                Container(width: DesignSize(context).calc(80), child: root()),
                Expanded(child: second())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget second() {
    var list = secNode(_currentRootName);
    return CustomScrollView(
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate((context, i) {
            return secondItem(list[i]);
          }, childCount: list.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1),
        )
      ],
      semanticChildCount: list.length,
    );
  }

  Widget secondItem(NodeModal e) {
    return TouchView(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return TopicList(node: e);
        }));
      },
      child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Image(
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                image: NetImage(e.getavatarNormal),
              ),
              Container(
                child: Text(
                  e.title,
                  style: TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }

  // 根节点
  Widget root() => Container(
          child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
            return rootItem(i);
          }, childCount: rootNode.length))
        ],
      ));

  TouchView rootItem(int i) {
    return TouchView(
        onTap: () {
          setState(() {
            _currentRootName = rootNode[i].name;
          });
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(4, 6, 6, 6),
            child: Text(rootNode[i].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: _currentRootName == rootNode[i].name
                        ? Colors.blue
                        : Colors.black54))));
  }
}
