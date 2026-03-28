class ArrivedGroupResponse {
  final int id;
  final String receiptCode;
  final String totalPrice;
  final String totalWeight;
  final String image;
  final String paymentStatus;
  final String? paymentCheck;
  final String? deliveryMethod;
  final String deliveryAddress;
  final DateTime createdAt;
  final List<CargoItem> cargos;
  final String adminNote;

  ArrivedGroupResponse({
    required this.id,
    required this.receiptCode,
    required this.totalPrice,
    required this.totalWeight,
    required this.image,
    required this.paymentStatus,
    this.paymentCheck,
    this.deliveryMethod,
    required this.deliveryAddress,
    required this.createdAt,
    required this.cargos,
    required this.adminNote,
  });

  factory ArrivedGroupResponse.fromJson(Map<String, dynamic> json) {
    return ArrivedGroupResponse(
      id: json['id'] ?? 0,
      receiptCode: json['receipt_code'] ?? "",
      totalPrice: json['total_price'] ?? "0",
      totalWeight: json['total_weight'] ?? "0",
      image: json['image'] ?? "",
      paymentStatus: json['payment_status'] ?? "",
      paymentCheck: json['payment_check'],
      deliveryMethod: json['delivery_method'],
      deliveryAddress: json['delivery_address'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
      adminNote: json['admin_note'] ?? "",
      cargos: (json['cargos'] as List?)
          ?.map((i) => CargoItem.fromJson(i))
          .toList() ?? [],
    );
  }
}

class CargoItem {
  final int id;
  final String trackCode;
  final String status;
  final DateTime createdAt;

  CargoItem({
    required this.id,
    required this.trackCode,
    required this.status,
    required this.createdAt,
  });

  factory CargoItem.fromJson(Map<String, dynamic> json) {
    return CargoItem(
      id: json['id'] ?? 0,
      trackCode: json['track_code'] ?? "",
      status: json['status'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}