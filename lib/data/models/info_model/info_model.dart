class InfoModel {
  final String? userId; // Backenddan keladigan foydalanuvchi IDsi
  final ShippingInfo xitoyAvia;
  final ShippingInfo xitoyAvto;
  final ContactInfo contact;

  InfoModel({
    this.userId,
    required this.xitoyAvia,
    required this.xitoyAvto,
    required this.contact,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      userId: json['user_id']?.toString(),
      xitoyAvia: ShippingInfo.fromJson(json['Xitoy_AVIA']),
      xitoyAvto: ShippingInfo.fromJson(json['Xitoy_AVTO']),
      contact: ContactInfo.fromJson(json['contact']),
    );
  }
}

class ShippingInfo {
  final String phone;
  final String address;
  final double price;
  final String term;

  ShippingInfo({
    required this.phone,
    required this.address,
    required this.price,
    required this.term,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
      phone: json['phone'] ?? "",
      address: json['address'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      term: json['term'] ?? "",
    );
  }
}

class ContactInfo {
  final String telegram;
  final String instagram;
  final String phone;

  ContactInfo({
    required this.telegram,
    required this.instagram,
    required this.phone,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      telegram: json['telegram'] ?? "",
      instagram: json['instagram'] ?? "",
      phone: json['phone'] ?? "",
    );
  }
}