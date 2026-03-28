// profile_event.dart
part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UserModel data;

  const UpdateProfileEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteAccountEvent extends ProfileEvent {}

class GetPassportsEvent extends ProfileEvent {}

class AddPassportEvent extends ProfileEvent {
  final UserRelativeModel model;

  const AddPassportEvent(this.model);

  @override
  List<Object?> get props => [model];
}

class DeletePassportEvent extends ProfileEvent {
  final int id;

  const DeletePassportEvent(this.id);

  @override
  List<Object?> get props => [id];
}