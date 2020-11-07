void main() {
  var str =
      '''@AngryPanda收到就好 楼主不是说了么，中间商http://sd.com 1.5 http://img.com/2.png 来收，赔钱所以不卖。真的 1.5 这样一单一单卖，还不如一下全给中间商呢。''';

  var at = r'@\w+';
  var url =
      r'((ht|f)tps?):\/\/)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-]';
  var pic =
      r'/^https?:\/\/(.+\/)+.+(\.(gif|png|jpg|jpeg|webp|svg|psd|bmp|tif))$/i';
  var reg = RegExp('($at)|($url)|($pic)');

  var str1 =
      str.replaceAllMapped(reg, (m) => "<replaceTag>${m[0]}<replaceTag>");

  print(str1);
  print(str1.split(r"<replaceTag>"));
  var list = reg.allMatches(str).map((m) {
    return m[0];
  }).toList();

  print(list);
}
