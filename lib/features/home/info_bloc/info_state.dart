part of 'info_bloc.dart';

class InfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InfoInitial extends InfoState {}
class InfoLoading extends InfoState {}

class InfoSuccess extends InfoState {
  final InfoModel model;
  InfoSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class InfoFailure extends InfoState {
  final String error;
  InfoFailure(this.error);

  @override
  List<Object?> get props => [error];
}