// lib/features/chat/bloc/chat_event.dart
part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetChatsEvent extends ChatEvent {
  final bool isAutoRefresh;

  GetChatsEvent({this.isAutoRefresh = false});

  @override
  List<Object?> get props => [isAutoRefresh];
}

class SendChatMessageEvent extends ChatEvent {
  final String? message;
  final File? image;

  SendChatMessageEvent({
    this.message,
    this.image,
  });

  @override
  List<Object?> get props => [message, image];
}

class StartAutoRefreshEvent extends ChatEvent {}

class StopAutoRefreshEvent extends ChatEvent {}