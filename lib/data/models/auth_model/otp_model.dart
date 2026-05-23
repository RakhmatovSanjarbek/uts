class OtpModel {
  final String phone;
  final String code;
  final String fcmToken;

  OtpModel({required this.phone, required this.code, required this.fcmToken});

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "otp_code": code,
    "fcm_token": fcmToken,
  };
}
