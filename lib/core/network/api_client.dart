import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
        onError: (DioException e, handler) async {
          if (e.response != null && e.response?.statusCode == 401) {
            await AuthService.logoutAndRedirect();
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
    final response = await _dio.get(endpoint, queryParameters: queryParams);
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
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
      ),
    );

    return _handleResponse(response);
  }

  Future<dynamic> patch(String path, {dynamic body}) async {
    final response = await _dio.patch(path, data: body);
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path, {dynamic body}) async {
    try {
      final response = await _dio.delete(path, data: body);
      return _handleResponse(response);
    } on DioException catch (e) {
      // Agar server 204 qaytarsa-yu, Dio baribir xatoga tushsa (kamdan-kam holat)
      if (e.response?.statusCode == 204) {
        return null;
      }
      rethrow;
    }
  }

  dynamic _handleResponse(Response response) {
    // 204 kelganda data har doim null bo'ladi, shuning uchun darrov qaytaramiz
    if (response.statusCode == 204) {
      debugPrint("API: Pasport o'chirildi (204 No Content)");
      return null;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    }

    if (response.statusCode == 401) {
      AuthService.logoutAndRedirect();
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }
}
