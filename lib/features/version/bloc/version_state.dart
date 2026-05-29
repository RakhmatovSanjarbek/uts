part of 'version_bloc.dart';

abstract class VersionState extends Equatable {
  const VersionState();

  @override
  List<Object?> get props => [];
}

class VersionInitial extends VersionState {
  const VersionInitial();
}

class VersionLoading extends VersionState {
  const VersionLoading();
}

class VersionUpdateRequired extends VersionState {
  final VersionModel model;

  const VersionUpdateRequired(this.model);

  @override
  List<Object?> get props => [model];
}

class VersionUpToDate extends VersionState {
  const VersionUpToDate();
}

class VersionError extends VersionState {
  final String message;

  const VersionError(this.message);

  @override
  List<Object?> get props => [message];
}