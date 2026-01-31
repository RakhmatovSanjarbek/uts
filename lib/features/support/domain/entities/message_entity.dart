class MessageEntity {
  final String token; // kim yuborgan (user / support)
  final String? message;
  final String? imagePath;
  final int date; // millisecondsSinceEpoch

  const MessageEntity({
    required this.token,
    this.message,
    this.imagePath,
    required this.date,
  });
}
