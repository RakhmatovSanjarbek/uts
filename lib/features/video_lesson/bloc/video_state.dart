part of 'video_bloc.dart';

class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoSuccess extends VideoState {
  final List<VideoModel> model;

  VideoSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class VideoFailure extends VideoState {
  final String error;

  VideoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
