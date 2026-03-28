part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final UserModel model;

  const ProfileSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class PassportsSuccess extends ProfileState {
  final List<UserRelativeModel> passports;

  const PassportsSuccess(this.passports);

  @override
  List<Object?> get props => [passports];
}

class ProfileFailure extends ProfileState {
  final String error;
  final UserModel? model;

  const ProfileFailure(this.error, {this.model});

  @override
  List<Object?> get props => [error, model];
}

class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}

class PassportActionSuccess extends ProfileState {
  final String message;

  const PassportActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}