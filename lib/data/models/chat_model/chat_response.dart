import 'chat_model.dart';

class ChatResponse {
  final List<ChatModel> chats;
  ChatResponse({required this.chats});
  ChatResponse copyWith({
    List<ChatModel>? chats,
  }) {
    return ChatResponse(
      chats: chats ?? this.chats,
    );
  }
  factory ChatResponse.fromJson(List json) {
    return ChatResponse(
      chats: json.map((e) => ChatModel.fromJson(e)).toList(),
    );
  }
}