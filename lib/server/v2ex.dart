import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:iv2ex/config.dart';

class V2EXAPI {
  static Dio get instance => _getinstance();

  static Dio _instance;

  static Dio _getinstance() {
    if (_instance == null) {
      _instance = new Dio(
          BaseOptions(baseUrl: baseURL, responseType: ResponseType.json));

      // 缓存
      _instance.interceptors
          .add(DioCacheManager(CacheConfig(baseUrl: baseURL)).interceptor);
      _instance.interceptors.add(InterceptorsWrapper(onError: (err) {
        print("""dio Error:${err.error}""");
      }, onRequest: (req) {
        print('''dio Request:${req.path} ${req.queryParameters} ${req.data}''');
      }, onResponse: (res) {
        print(
            '''dio Response: ${res.statusCode} ${res.request.path} ${res.statusMessage} ''');
      }));
    }
    return _instance;
  }
}
