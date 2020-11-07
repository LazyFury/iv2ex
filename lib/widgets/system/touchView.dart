import 'dart:async';

import 'package:flutter/material.dart';

class TouchView extends StatefulWidget {
  const TouchView({Key key, this.child, this.onTap}) : super(key: key);

  final onTap;
  final Widget child;
  @override
  TouchViewState createState() => TouchViewState();
}

class TouchViewState extends State<TouchView> {
  double opacity = 1.0;

  updateOpacity(double o) {
    // print(o);
    setState(() {
      opacity = o;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (e) {
          updateOpacity(0.6);
        },
        onTapCancel: () {
          updateOpacity(1.0);
        },
        onTapUp: (e) {},
        onTap: () {
          Timer(Duration(milliseconds: 50), () {
            updateOpacity(1.0);
          });
          if (widget.onTap != null) {
            widget.onTap();
          }
        },
        child: widget.child,
      ),
    );
  }
}
