// user_relative_model.dart
class UserRelativeModel {
  final int? id;
  final String? fullName;
  final String? jshshir;
  final String? passportSeries;
  final String? birthDate;
  final String? phone;
  final String? createdAt;

  UserRelativeModel({
    this.id,
    this.fullName,
    this.jshshir,
    this.passportSeries,
    this.birthDate,
    this.phone,
    this.createdAt,
  });

  factory UserRelativeModel.fromJson(Map<String, dynamic> json) {
    return UserRelativeModel(
      id: json['id'] as int?,
      fullName: json['full_name'] as String?,
      jshshir: json['jshshir'] as String?,
      passportSeries: json['passport_series'] as String?,
      birthDate: json['birth_date'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'jshshir': jshshir,
      'passport_series': passportSeries,
      'birth_date': birthDate,
      'phone': phone,
      'created_at': createdAt,
    };
  }
}