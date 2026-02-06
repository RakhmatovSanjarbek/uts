part of 'auth_bloc.dart';

abstract class AuthState extends Equatable{
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final AuthResponse response;
  const AuthSuccess(this.response);
  @override
  List<Object?> get props => [response];
}
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  @override
  List<Object?> get props => [error];
}
class AuthNeedRegister extends AuthState {
  final String phone;
  const AuthNeedRegister(this.phone);
  @override
  List<Object?> get props => [phone];
}