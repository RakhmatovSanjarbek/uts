// lib/features/chat/bloc/chat_state.dart
part of 'chat_bloc.dart';

class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final bool isAutoRefresh;

  ChatLoading({this.isAutoRefresh = false});

  @override
  List<Object?> get props => [isAutoRefresh];
}

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