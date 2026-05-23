// features/auth/bloc/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String phone;
  SignInEvent(this.phone);
}

class SignUpEvent extends AuthEvent {
  final SignUpModel model;
  SignUpEvent(this.model);
}

class OtpEvent extends AuthEvent {
  final String phone;
  final String code;
  final String fcmToken;
  OtpEvent(this.phone, this.code, this.fcmToken);
}

class LogoutEvent extends AuthEvent {}

class UpdateUserEvent extends AuthEvent {
  final UserModel user;
  UpdateUserEvent(this.user);
}