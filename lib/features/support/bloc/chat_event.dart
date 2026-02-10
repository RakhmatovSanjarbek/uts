part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetChatsEvent extends ChatEvent {}

class SendChatMessageEvent extends ChatEvent {
  final String? message;
  final File? image;

  SendChatMessageEvent({
    this.message,
    this.image,
  });

  @override
  List<Object?> get props => [ message, image];
}
