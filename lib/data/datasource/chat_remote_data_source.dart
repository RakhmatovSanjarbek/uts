import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/network/api_client.dart';

import '../models/chat_model/chat_response.dart';

class ChatRemoteDataSource {
  final ApiClient client;

  ChatRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<ChatResponse> getChats() async {
    final token = await getToken();
    final client = ApiClient(token: token);

    final res = await client.get('/api/cargo/chat/');
    return ChatResponse.fromJson(res);
  }

  Future<void> sendMessage({
    String? message,
    File? image,
  }) async {
    final token = await getToken();
    final client = ApiClient(token: token);

    final formData = FormData.fromMap({
      if (message != null) "message": message,
      if (image != null)
        "image": await MultipartFile.fromFile(image.path),
    });

    await client.post(
      '/api/cargo/chat/',
      body: formData,
      isMultipart: true, // 👈 MUHIM
    );
  }

}
