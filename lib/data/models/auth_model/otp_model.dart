class OtpModel {
  final String phone;
  final String code;

  OtpModel({required this.phone, required this.code});

  Map<String, dynamic> toJson() => {"phone": phone, "otp_code": code};
}
