import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

typedef loadAPI = Future<dynamic> Function();

class PageList extends StatefulWidget {
  final loadAPI load;
  final List<Widget> children;
  final Widget skeleton;
  final int skeletonCount;
  final Widget emptyWidget;

  const PageList(
      {Key key,
      @required this.load,
      @required this.children,
      @required this.skeleton,
      this.skeletonCount,
      this.emptyWidget})
      : super(key: key);
  @override
  State<PageList> createState() => PageListState();
}

class PageListState extends State<PageList> {
  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      onRefresh: () async {
        widget.load();
      },
      emptyWidget: widget.emptyWidget,
      slivers: [sliver()],
    );
  }

  SliverList sliver() {
    return (widget.children.length > 0)
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return widget.children[index];
            }, childCount: widget.children.length),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return widget.skeleton;
            }, childCount: widget.skeletonCount ?? 5),
          );
  }
}
