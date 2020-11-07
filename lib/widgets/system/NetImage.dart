// import 'dart:typed_data';

import 'dart:async';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class NetImage extends ImageProvider<NetImage> {
  final double scale;
  final String image; //图片地址
  final String asset; //备用的本地资源地址，如果没有则默认的空文件未一个1像素的透明图片
  const NetImage(this.image, {this.scale = 1, this.asset})
      : assert(scale != null),
        assert(image != null);

  /// decode 解码jpg的一个异步函数，需要传入图片的uint8list数据
  /// chunkEvents 向Image通知加载情况的
  @override
  ImageStreamCompleter load(NetImage key, DecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
    );
  }

  /// 为图片资源生成唯一的key，在后续更新中使用key查看图片是否在缓存中
  @override
  Future<NetImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetImage>(this);
  }

  /// 判断图片是否需要缓存
  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final NetImage typedOther = other;
    return image == typedOther.image && scale == typedOther.scale;
  }

  @override
  int get hashCode => ui.hashValues(image, scale);

  @override
  String toString() =>
      '$runtimeType(${describeIdentity(image)}, scale: $scale)';

  /// 使用网络加载图片的方法
  Future<ui.Codec> _loadAsync(
      NetImage key,
      StreamController<ImageChunkEvent> chunkEvents,
      DecoderCallback decode) async {
    //默认的空文件，尝试在这里避免所有throw的请求，因为官方提供的NetworkImage在网络地址错误的时候会carsh掉
    Uint8List defaultImage = emptyImage;
    if (this.asset != null) {
      //如果提供了默认的empty，尝试加载bytes
      try {
        ByteData bytes = await rootBundle.load(this.asset);
        defaultImage = bytes.buffer.asUint8List();
      } catch (err) {}
    }

    //这里try不为catch错误，而是在结束的时候关闭chunkEvents
    try {
      assert(key == this);
      Uint8List result = defaultImage;
      // print("请求图片资源：" + img.path);
      chunkEvents.add(ImageChunkEvent(
        cumulativeBytesLoaded: 0,
        expectedTotalBytes: 100,
      ));
      // 尝试请求网络资源
      Response<Uint8List> response = await Dio().get<Uint8List>(key.image,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (count, total) {
        chunkEvents.add(ImageChunkEvent(
          cumulativeBytesLoaded: count,
          expectedTotalBytes: total,
        ));
      }).catchError((err) {
        print('''加载图片失败: ${key.image}''');
      });
      // print(response);

      if (response != null && response.data != null) {
        result = response.data;
        if (response.headers.value('content-type') == 'image/svg+xml') {
          print("svg");
          var svgRoot = await svg.fromSvgBytes(response.data, key.image);
          var pic =
              svgRoot.toPicture(size: Size(100, 100), clipToViewBox: false);
          var img = await pic.toImage(100, 100);
          var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
          result = byteData.buffer.asUint8List();
        }
      }

      // 如果res内容为空
      if (result.lengthInBytes == 0) {
        chunkEvents.addError("空文件 $image");
        result = defaultImage;
      }
      // 如果错误的链接被指向了404页面，则获取到res为html 文本，这里会解码失败
      try {
        return decode(result);
      } catch (err) {}
      // 如果解码失败,返回空文件
      return decode(defaultImage);
    } finally {
      chunkEvents.close();
    }
  }
}

// 1像素空白图
Uint8List emptyImage = Uint8List.fromList([
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  1,
  3,
  0,
  0,
  0,
  37,
  219,
  86,
  202,
  0,
  0,
  0,
  1,
  115,
  82,
  71,
  66,
  1,
  217,
  201,
  44,
  127,
  0,
  0,
  0,
  9,
  112,
  72,
  89,
  115,
  0,
  0,
  11,
  19,
  0,
  0,
  11,
  19,
  1,
  0,
  154,
  156,
  24,
  0,
  0,
  0,
  3,
  80,
  76,
  84,
  69,
  0,
  0,
  0,
  167,
  122,
  61,
  218,
  0,
  0,
  0,
  1,
  116,
  82,
  78,
  83,
  0,
  64,
  230,
  216,
  102,
  0,
  0,
  0,
  10,
  73,
  68,
  65,
  84,
  120,
  156,
  99,
  96,
  0,
  0,
  0,
  2,
  0,
  1,
  72,
  175,
  164,
  113,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130
]);
