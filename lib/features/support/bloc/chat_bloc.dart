import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/domain/repositories/chat_repository.dart';
import '../../../data/models/chat_model/chat_model.dart';
import '../../../data/models/chat_model/chat_response.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  ChatResponse? _lastResponse;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<GetChatsEvent>(_onGetChats);
    on<SendChatMessageEvent>(_onSendMessage);
  }

  Future<void> _onGetChats(
      GetChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    if (!event.isAutoRefresh && state is! ChatSuccess) {
      emit(ChatLoading());
    }
    try {
      final res = await repository.getChats();
      _lastResponse = res;
      emit(ChatSuccess(res));
    } catch (e) {
      if (!event.isAutoRefresh) {
        emit(ChatFailure(_mapError(e)));
      }
    }
  }

  Future<void> _onSendMessage(
      SendChatMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    final base = state is ChatSuccess
        ? (state as ChatSuccess).response
        : _lastResponse;

    if (base == null) {
      await _onGetChats(GetChatsEvent(), emit);
      add(SendChatMessageEvent(message: event.message, image: event.image));
      return;
    }

    final optimisticMsg = ChatModel(
      message: event.message,
      image: event.image?.path,
      isFromAdmin: false,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      senderType: 'Client',
    );
    emit(ChatSuccess(base.copyWith(chats: [...base.chats, optimisticMsg])));

    try {
      await repository.sendMessage(
        message: event.message,
        image: event.image,
      );
      add(GetChatsEvent(isAutoRefresh: true));
    } catch (e) {
      emit(ChatSuccess(base));
      emit(ChatFailure(_mapError(e)));
    }
  }

  String _mapError(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Xatolik yuz berdi';
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return "Internet bilan aloqa yo'q";
      }
      return 'Tarmoq xatoligi yuz berdi';
    }
    return e.toString();
  }
}