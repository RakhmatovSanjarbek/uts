class ChatEntity {
  final String? message;
  final String? image;
  final bool isFromAdmin;
  final String senderType;
  final int timestampMs;

  ChatEntity({
    this.message,
    this.image,
    required this.isFromAdmin,
    required this.senderType,
    required this.timestampMs,
  });
}
