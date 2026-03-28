class SignUpModel {
  final String phone;
  final String firstName;
  final String lastName;
  final String jshshir;
  final String passportSeries;
  final String birthDate;
  final String address;
  final String? relativeFullName;
  final String? relativeJshshir;
  final String? relativePassportSeries;
  final String? relativePhone;

  SignUpModel({
    required this.address,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.jshshir,
    required this.passportSeries,
    required this.birthDate,
    this.relativeFullName,
    this.relativeJshshir,
    this.relativePassportSeries,
    this.relativePhone,
  });

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "first_name": firstName,
    "last_name": lastName,
    "jshshir": jshshir,
    "passport_series": passportSeries,
    "birth_date": birthDate,
    "address": address,
    "relative_full_name": relativeFullName,
    "relative_jshshir": relativeJshshir,
    "relative_passport_series": relativePassportSeries,
    "relative_phone": relativePhone,
  };
}
