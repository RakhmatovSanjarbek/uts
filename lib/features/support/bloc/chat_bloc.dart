import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/domain/repositories/chat_repository.dart';

import '../../../data/models/chat_model/chat_model.dart';
import '../../../data/models/chat_model/chat_response.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<GetChatsEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final res = await repository.getChats();
        emit(ChatSuccess(res));
      } catch (e) {
        emit(ChatFailure(_mapErrorToMessage(e)));
      }
    });
    on<SendChatMessageEvent>((event, emit) async {
      final currentState = state;
      if (currentState is ChatSuccess) {
        try {
          await repository.sendMessage(
            message: event.message,
            image: event.image,
          );
          final myNewMsg = ChatModel(
            message: event.message,
            image: event.image?.path,
            isFromAdmin: false,
            timestampMs: DateTime.now().millisecondsSinceEpoch,
            senderType: 'Client',
          );
          final List<ChatModel> updatedList = [
            ...currentState.response.chats,
            myNewMsg,
          ];
          emit(ChatSuccess(currentState.response.copyWith(chats: updatedList)));
        } catch (e) {
          emit(ChatFailure(_mapErrorToMessage(e)));
        }
      }
    });
  }

  String _mapErrorToMessage(dynamic e) {
    if (e is DioException) {
      final dynamic data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            "Xatolik yuz berdi";
      }
      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}
