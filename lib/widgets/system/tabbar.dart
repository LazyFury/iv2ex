import 'package:flutter/material.dart';
import 'package:iv2ex/widgets/system/touchView.dart';

class TabbarIcon {
  String name = "";
  IconData icon;

  TabbarIcon({@required this.name, @required this.icon});
}

class Tabbar extends StatefulWidget {
  const Tabbar({Key key, this.tabbars, this.onChange}) : super(key: key);

  final List<TabbarIcon> tabbars;
  final Function(int) onChange;
  @override
  TabbarState createState() => TabbarState();
}

class TabbarState extends State<Tabbar> {
  int current = 0;

  Row buildRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.tabbars
            .asMap()
            .map((i, e) {
              return MapEntry(
                i,
                tabbarItem(
                  current == i,
                  i,
                  name: e.name,
                  icon: e.icon,
                ),
              );
            })
            .values
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildRow(),
            ]),
      ),
    );
  }

  Widget tabbarItem(bool selected, int i, {icon, name}) {
    var color = selected ? Colors.blue : Colors.black;
    return TouchView(
      onTap: () {
        setState(() {
          current = i;
          widget.onChange(i);
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          Text(
            name,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
