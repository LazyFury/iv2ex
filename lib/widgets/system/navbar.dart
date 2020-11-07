// navbar
import 'package:flutter/material.dart';
import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

Widget navbar(context,
    {String title = "标题",
    List<Widget> leftButton,
    List<Widget> rightButton,
    Color color}) {
  return Container(
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      // boxShadow: [
      //   BoxShadow(blurRadius: 20, offset: Offset(10, 0), spreadRadius: 2)
      // ],
    ),
    child: Column(children: <Widget>[
      safeAreaTop(context),
      // navbar
      Container(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            slideBox(context,
                children:
                    leftButton == null ? [getBackButton(context)] : leftButton),
            // Text(statusBarHeight(context).toString()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
            ),
            slideBox(context,
                children: rightButton != null ? rightButton : [],
                isleft: false),
          ],
        ),
      )
    ]),
  );
}

Widget slideBox(context, {List<Widget> children, bool isleft: true}) =>
    Container(
      child: Row(
        mainAxisAlignment:
            isleft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: children,
      ),
      width: 80,
    );

// 是否显示返回按钮
Widget getBackButton(context) {
  if (ModalRoute.of(context) != null && ModalRoute.of(context).canPop) {
    return TouchView(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: Colors.grey,
              size: 20,
            ),
            Text(
              "返回",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
  return Row();
}
