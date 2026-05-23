class OrderModel {
  final int id;
  final String trackCode;
  final String resCode;
  final String status;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.trackCode,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    required this.resCode,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      trackCode: json['track_code'],
      resCode: json['flight_name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
    );
  }
}
