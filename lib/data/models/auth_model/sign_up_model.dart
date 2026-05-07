import 'dart:io';

class SignUpModel {
  final String phone;
  final String firstName;
  final String lastName;
  final String jshshir;
  final String passportSeries;
  final String birthDate;
  final String address;
  final File? passportFront;
  final File? passportBack;

  SignUpModel({
    required this.address,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.jshshir,
    required this.passportSeries,
    required this.birthDate,
    this.passportFront,
    this.passportBack,
  });

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "first_name": firstName,
    "last_name": lastName,
    "jshshir": jshshir,
    "passport_series": passportSeries,
    "birth_date": birthDate,
    "address": address,
  };

  Future<Map<String, dynamic>> toMap() async {
    return {
      "phone": phone,
      "first_name": firstName,
      "last_name": lastName,
      "jshshir": jshshir,
      "passport_series": passportSeries,
      "birth_date": birthDate,
      "address": address,
    };
  }
}
