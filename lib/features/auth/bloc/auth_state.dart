// features/auth/bloc/auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  bool get isAuthenticated => this is AuthenticatedState;
  bool get isPending => this is PendingState;
  bool get isRejected => this is RejectedState;
  bool get isUnauthenticated => this is UnauthenticatedState;
  bool get isLoading => this is AuthLoading;
  bool get hasToken => this is TokenExistsState || this is AuthenticatedState || this is PendingState || this is RejectedState;

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Token bor, lekin user statusi hali aniqlanmagan
class TokenExistsState extends AuthState {
  final String token;
  const TokenExistsState({required this.token});

  @override
  List<Object?> get props => [token];
}

class AuthenticatedState extends AuthState {
  final String token;
  final UserModel user;
  const AuthenticatedState({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class PendingState extends AuthState {
  final String token;
  final UserModel user;
  const PendingState({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class RejectedState extends AuthState {
  final String token;
  final UserModel user;
  const RejectedState({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class UnauthenticatedState extends AuthState {}

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