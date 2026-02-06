class SignUpModel {
  final String phone;
  final String firstName;
  final String lastName;
  final String jshshir;
  final String passportSeries;
  final String birthDate;

  SignUpModel({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.jshshir,
    required this.passportSeries,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "first_name": firstName,
    "last_name": lastName,
    "jshshir": jshshir,
    "passport_series": passportSeries,
    "birth_date": birthDate,
  };
}
