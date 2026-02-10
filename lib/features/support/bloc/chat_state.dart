part of 'chat_bloc.dart';

class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final ChatResponse response;

  ChatSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ChatFailure extends ChatState {
  final String error;

  ChatFailure(this.error);

  @override
  List<Object?> get props => [error];
}
