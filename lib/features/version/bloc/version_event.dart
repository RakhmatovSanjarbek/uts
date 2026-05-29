part of 'version_bloc.dart';

abstract class VersionEvent extends Equatable {
  const VersionEvent();

  @override
  List<Object?> get props => [];
}

class CheckAppVersionEvent extends VersionEvent {
  const CheckAppVersionEvent();
}