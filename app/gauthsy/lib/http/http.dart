library http;

import 'package:dio/dio.dart';
import 'package:gauthsy/kernel/container/container.dart';

class Http {
  final _http = Dio();

  static void init() {
    Container().set("http", () => Http());
  }

  Future<Response> get(String url, {Map<String, dynamic> headers, ResponseType responseType}) {
    return _http.get(url, options: Options(headers: headers, responseType: responseType));
  }

  Future<Response> download(String url, String fileDir) {
    return _http.download(url, fileDir);
  }
}
