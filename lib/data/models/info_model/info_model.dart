class InfoModel {
  final String? userId;
  final ShippingInfo xitoyAvia;
  final ShippingInfo xitoyAvto;
  final ContactInfo contact;
  final double dollarRate;
  final PaymentCard paymentCard;
  final PickupLocation pickup;

  InfoModel({
    this.userId,
    required this.xitoyAvia,
    required this.xitoyAvto,
    required this.contact,
    this.dollarRate = 0,
    required this.paymentCard,
    required this.pickup,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      userId: json['user_id']?.toString(),
      xitoyAvia: ShippingInfo.fromJson(json['Xitoy_AVIA']),
      xitoyAvto: ShippingInfo.fromJson(json['Xitoy_AVTO']),
      contact: ContactInfo.fromJson(json['contact']),
      dollarRate: (json['dollar_rate'] ?? 0).toDouble(),
      paymentCard: json['payment_card'] != null
          ? PaymentCard.fromJson(json['payment_card'])
          : PaymentCard(number: '', holder: ''),
      pickup: json['pickup'] != null
          ? PickupLocation.fromJson(json['pickup'])
          : PickupLocation(name: '', lat: 41.334485, lng: 69.214603),
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
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      term: json['term'] ?? '',
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
      telegram: json['telegram'] ?? '',
      instagram: json['instagram'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class PaymentCard {
  final String number;
  final String holder;

  PaymentCard({required this.number, required this.holder});

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      number: json['number'] ?? '',
      holder: json['holder'] ?? '',
    );
  }
}

class PickupLocation {
  final String name;
  final double lat;
  final double lng;

  PickupLocation({required this.name, required this.lat, required this.lng});

  factory PickupLocation.fromJson(Map<String, dynamic> json) {
    return PickupLocation(
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 41.334485).toDouble(),
      lng: (json['lng'] ?? 69.214603).toDouble(),
    );
  }
}