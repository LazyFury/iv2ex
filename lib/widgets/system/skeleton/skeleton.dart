import 'package:flutter/material.dart';
import 'package:iv2ex/utils/utils.dart';

class Skeleton {
  static BoxDecoration decoration() {
    return BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(2));
  }

  static Widget headPic(BuildContext context, {double width, double height}) {
    return Container(
        decoration: decoration(),
        // margin: EdgeInsets.only(left: 10),
        width: DesignSize(context).calc(width ?? 64),
        height: DesignSize(context).calc(height ?? 64));
  }

  static Widget line(BuildContext context, {double width, double height}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: SkeletonFrame(
        child: Container(
            decoration: decoration(),
            width: DesignSize(context).calc(width ?? 64),
            height: DesignSize(context).calc(height ?? 10)),
      ),
    );
  }
}

class SkeletonFrame extends StatefulWidget {
  final Widget child;

  SkeletonFrame({Key key, this.child}) : super();
  @override
  SkeletonFrameState createState() => SkeletonFrameState();
}

class SkeletonFrameState extends State<SkeletonFrame>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1600), vsync: this);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
            child: ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FractionallySizedBox(
                child: child,
                widthFactor: .4,
                alignment: AlignmentGeometryTween(
                  begin: Alignment(-1.0 - .2 * 3, .0),
                  end: Alignment(1.0 + .2 * 3, .0),
                ).chain(CurveTween(curve: Curves.ease)).evaluate(_controller),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.grey[200],
                Colors.grey[100],
                Colors.grey[200],
              ])),
            ),
          ),
        )),
      ],
    );
  }
}
