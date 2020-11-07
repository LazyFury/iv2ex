import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' show Node;
import 'package:iv2ex/widgets/system/NetImage.dart';

Widget renderContent(BuildContext context, String content) {
  content = content.replaceAll(RegExp(r'[\r\n]+'), "\n\n");

  var at = r'@\w+';
  // com|net|cn|org|app|live|top|xyz|work|site|com.cn|online|tv|ltd|tech|club|ink|store
  var url =
      r'https?:\/\/([a-zA-Z0-9 % \- \.]+\.[a-zA-Z]{2,6})+[\w\/ % & = @ \-  _ \;  ~ \. \? # \u4E00-\u9FA5]+';

  var localUrl = r'\/(go|t)\/[a-zA-Z0-9]+';

  var pic = '$url(\.(gif|png|jpg|jpeg|webp|svg|psd|bmp|tif))';
  var elImg =
      r'''\<img.+src=[\'\"](https?:\/\/[\w\/ % & = @ \- \;  _ \? \u4E00-\u9FA5 \.]+)[\'\"].+(\>|\/\>|\<\/img\>)''';
  var img =
      r'\!\[([\w\d\s\u4E00-\u9FA5 \.]*)\]\(\s?(https?:\/\/[\w\/ % & = @ \- \;  _ \? \u4E00-\u9FA5 \.]+)\)';
  var reg = RegExp('($at|$img|$elImg|$pic|$url|$localUrl)');

  var str1 = content.replaceAllMapped(reg, (m) {
    return "<replaceTag>${m[0]}<replaceTag>";
  });
  // print(content);
  // print(str1.split(r"<replaceTag>"));
  showNode(Node el) {
    print("el内容：" + el.text);
  }

  var document = parse('''$str1''');
  document.nodes.forEach((element) {
    showNode(element);
  });
  return Text.rich(TextSpan(children: [
    ...str1.split(r"<replaceTag>").map((e) {
      var atReg = RegExp('$at');
      var picReg = RegExp('$pic');
      var imgReg = RegExp('$img');
      var urlReg = RegExp('$url');
      var elImgReg = RegExp("$elImg");
      if (atReg.hasMatch(e)) {
        return TextSpan(text: e, style: TextStyle(color: Colors.blue));
      }

      if (elImgReg.hasMatch(e)) {
        var match = elImgReg.firstMatch(e);
        var title = match.group(1);
        var url = match.group(1);
        if (url != null) {
          return WidgetSpan(child: imgWidget(url));
        }
      }

      if (imgReg.hasMatch(e)) {
        var match = imgReg.firstMatch(e);
        var title = match.group(1);
        var url = match.group(2);
        print("markdown img url:" + url);
        if (url != "") {
          return WidgetSpan(
              child: Column(
            children: [
              imgWidget(url),
              Text(
                title ?? "引用图片",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ));
        }
      }

      if (picReg.hasMatch(e)) {
        return WidgetSpan(child: imgWidget(e));
      }

      if (urlReg.hasMatch(e)) {
        return TextSpan(text: e, style: TextStyle(color: Colors.blue));
      }

      return TextSpan(text: e);
    }).toList()
  ]));
}

Widget imgWidget(String url) {
  return Image(
    image: NetImage(url),
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return Text(
          "loading img ..." + loadingProgress.cumulativeBytesLoaded.toString());
    },
    errorBuilder: (context, obj, trace) {
      print("err:" + url);
      return Text("imgErr");
    },
  );
}
