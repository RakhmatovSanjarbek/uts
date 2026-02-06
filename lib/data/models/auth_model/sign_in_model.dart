class SignInModel {
  final String phone;

  SignInModel({required this.phone});

  Map<String, dynamic> toJson() => {"phone": phone};
}
