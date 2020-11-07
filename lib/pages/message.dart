import 'package:flutter/material.dart';
import 'package:iv2ex/widgets/system/list/empty.dart';
import 'package:iv2ex/widgets/system/navbar.dart';

class Message extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessageState();
  }
}

class MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          children: [
            navbar(context, title: "消息"),
            Expanded(
                child: Column(
              children: [Empty()],
            )),
          ],
        ),
      ),
    );
  }
}
