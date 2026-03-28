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
  final SignUpModel model;

  SignUpEvent(
    this.model
  );
}

class OtpEvent extends AuthEvent {
  final String phone;
  final String code;

  OtpEvent(this.phone, this.code);
}
