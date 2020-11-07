import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(60),
      child: Column(
        children: [
          SvgPicture.asset("assets/image/empty.svg"),
          Text(
            "没有内容～",
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }
}
