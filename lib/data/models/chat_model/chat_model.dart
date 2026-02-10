import '../../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    super.message,
    super.image,
    required super.isFromAdmin,
    required super.senderType,
    required super.timestampMs,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'],
      image: json['image'],
      isFromAdmin: json['is_from_admin'],
      senderType: json['sender_type'],
      timestampMs: json['timestamp_ms'],
    );
  }
}
