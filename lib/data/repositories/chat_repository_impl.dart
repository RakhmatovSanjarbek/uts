import 'dart:io';

import 'package:uts_cargo/data/datasource/chat_remote_data_source.dart';
import 'package:uts_cargo/data/models/chat_model/chat_response.dart';
import 'package:uts_cargo/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<ChatResponse> getChats() async {
    return await remote.getChats();
  }

  @override
  Future<void> sendMessage({
    String? message,
    File? image,
  }) async {
    await remote.sendMessage(
      message: message,
      image: image,
    );
  }
}
