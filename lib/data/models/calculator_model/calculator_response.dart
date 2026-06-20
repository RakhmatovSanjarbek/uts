class CalculatorResponse {
  final String image;
  final double weight;
  final double length;
  final double width;
  final double height;
  final String? comment;
  final String? price;
  final String? adminNote;
  final bool isResponded;
  final DateTime createdAt;

  CalculatorResponse({
    required this.image,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.comment,
    this.price,
    this.adminNote,
    required this.isResponded,
    required this.createdAt,
  });

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) {
    return CalculatorResponse(
      image: json['image']?.toString() ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      comment: json['comment'] as String?,
      price: json['price']?.toString(),
      adminNote: json['admin_note'] as String?,
      isResponded: json['is_responded'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}