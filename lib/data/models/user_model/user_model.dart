class UserModel {
  final int id;
  final String userId;
  final String phone;
  final String firstName;
  final String lastName;
  final String jshshir;
  final String passportSeries;
  final String birthDate;
  final String address;

  UserModel({
    required this.id,
    required this.userId,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.jshshir,
    required this.passportSeries,
    required this.birthDate,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['user_id'],
      phone: json['phone'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      jshshir: json['jshshir'],
      passportSeries: json['passport_series'],
      birthDate: json['birth_date'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'jshshir': jshshir,
      'passport_series': passportSeries,
      'birth_date': birthDate,
      'address': address,
    };
  }
}
