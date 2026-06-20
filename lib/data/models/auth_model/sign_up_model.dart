import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/utils/image_utils.dart';

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
}

Future<FormData> buildSignUpFormData(SignUpModel model) async {
  final map = <String, dynamic>{
    "phone": model.phone,
    "first_name": model.firstName,
    "last_name": model.lastName,
    "jshshir": model.jshshir,
    "passport_series": model.passportSeries,
    "birth_date": model.birthDate,
    "address": model.address,
  };

  if (model.passportFront != null) {
    map["passport_front"] = await toMultipart(model.passportFront!, prefix: 'passport');
  }
  if (model.passportBack != null) {
    map["passport_back"] = await toMultipart(model.passportBack!, prefix: 'passport');
  }

  return FormData.fromMap(map);
}