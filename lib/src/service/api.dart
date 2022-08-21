import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import '../model/base_response.dart';

class ApiService {
  static final log = Logger();
  static final url = dotenv.env['DEV_URL'];

  static final options = BaseOptions(
    baseUrl: url!,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  static Dio dio = Dio(options);

  static Future<BaseResponse> getAllMarker() async {
    // log.i(url);
    try {
      String endpoint = 'device_list';
      var response = await dio.get(endpoint);
      var data = response.data;

      return BaseResponse.fromJson(data);
    } on DioError catch (e) {
      log.e(e.toString());
      return BaseResponse(
        status: false,
        message: e.message,
      );
    } catch (e) {
      log.e(e.toString());
      return BaseResponse(
        status: false,
        message: e.toString(),
      );
    }
  }
}
