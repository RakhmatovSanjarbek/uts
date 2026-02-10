import 'chat_model.dart';

class ChatResponse {
  final List<ChatModel> chats;

  // Konstruktor nomlangan parametrlar bilan
  ChatResponse({required this.chats});

  // copyWith metodi - yangi listni qabul qilish uchun
  ChatResponse copyWith({
    List<ChatModel>? chats,
  }) {
    return ChatResponse(
      chats: chats ?? this.chats,
    );
  }

  // JSON dan model yaratish
  factory ChatResponse.fromJson(List json) {
    return ChatResponse(
      chats: json.map((e) => ChatModel.fromJson(e)).toList(),
    );
  }
}