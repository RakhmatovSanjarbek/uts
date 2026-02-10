import 'package:dio/dio.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/service/auth_service.dart';

class ApiClient {
  final Dio _dio;
  final String? token;

  ApiClient({this.token})
      : _dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: {"Accept": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500,
    ),
  ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null && token!.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 && token != null) {
            AuthService.clearToken();
            AuthService.redirectToLogin();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
      }) async {
    final response = await _dio.get(
      endpoint,
      queryParameters: queryParams,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
      String path, {
        dynamic body,
        bool isMultipart = false,
      }) async {
    final response = await _dio.post(
      path,
      data: body,
      options: Options(
        contentType:
        isMultipart ? 'multipart/form-data' : 'application/json',
      ),
    );

    return _handleResponse(response);
  }


  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data; // ❗ HECH NIMA O‘RAMA
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }
}


