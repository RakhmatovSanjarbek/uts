import 'dart:io';

import '../../data/models/chat_model/chat_response.dart';

abstract class ChatRepository {
  Future<ChatResponse> getChats();

  Future<void> sendMessage({
    String? message,
    File? image,
  });
}
