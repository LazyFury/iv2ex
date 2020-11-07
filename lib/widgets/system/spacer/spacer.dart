import 'package:flutter/material.dart';

List<Widget> spacer(List<Widget> children) {
  return children.asMap().entries.map((e) {
    var i = e.key;
    var v = e.value;
    var isFirst = i == 0;
    var isLast = i == children.length - 1;
    return Container(
      child: v,
      margin: EdgeInsets.fromLTRB(isFirst ? 0 : 4, 0, isLast ? 0 : 4, 0),
    );
  }).toList();
}
