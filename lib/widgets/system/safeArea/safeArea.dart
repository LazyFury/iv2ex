import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iv2ex/utils/utils.dart';

Widget safeAreaTop(BuildContext context) {
  return Container(
    height: safeArea(context).top,
    width: double.infinity,
  );
}

Widget safeAreaBottom(BuildContext context) {
  return Container(
    height: safeArea(context).bottom,
    width: double.infinity,
  );
}
