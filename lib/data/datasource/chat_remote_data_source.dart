import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/network/api_client.dart';

import '../../core/utils/image_utils.dart';
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
    final c = ApiClient(token: token);
    final res = await c.get('/api/services/chat/');
    return ChatResponse.fromJson(res);
  }

  Future<void> sendMessage({String? message, File? image}) async {
    final token = await getToken();
    final c = ApiClient(token: token);

    final map = <String, dynamic>{};
    if (message != null && message.isNotEmpty) map['message'] = message;
    if (image != null) map['image'] = await toMultipart(image, prefix: 'chat');

    await c.post(
      '/api/services/chat/',
      body: FormData.fromMap(map),
      isMultipart: true,
    );
  }
}