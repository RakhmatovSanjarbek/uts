part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel model;

  ProfileSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}
