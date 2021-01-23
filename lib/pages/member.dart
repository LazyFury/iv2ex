import 'package:flutter/material.dart';
import 'package:iv2ex/pages/webview.dart';
import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

class Member extends StatefulWidget {
  @override
  State<Member> createState() => MemberState();
}

class MemberState extends State<Member> {
  @override
  Widget build(context) {
    return Material(
      child: Center(
        child: Column(
          children: [
            safeAreaTop(context),
            Text("member"),
            TouchView(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return webview(context, "https://www.v2ex.com/signin");
                }));
              },
              child: Text("login"),
            ),
            TouchView(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return webview(context, "https://www.v2ex.com");
                }));
              },
              child: Text("v2ex"),
            )
          ],
        ),
      ),
    );
  }
}
