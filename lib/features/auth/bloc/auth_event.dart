part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  final String phone;

  SignInEvent(this.phone);
}

class SignUpEvent extends AuthEvent {
  final String phone;
  final String firstName;
  final String lastName;
  final String jshshir;
  final String passportSeries;
  final String birthDate;

  SignUpEvent(
    this.phone,
    this.firstName,
    this.lastName,
    this.jshshir,
    this.passportSeries,
    this.birthDate,
  );
}

class OtpEvent extends AuthEvent {
  final String phone;
  final String code;

  OtpEvent(this.phone, this.code);
}
