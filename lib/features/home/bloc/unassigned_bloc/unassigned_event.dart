part of 'unassigned_bloc.dart';

abstract class UnassignedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUnassignedEvent extends UnassignedEvent {}

class LoadMoreUnassignedEvent extends UnassignedEvent {}

class SearchUnassignedEvent extends UnassignedEvent {
  final String query;
  SearchUnassignedEvent(this.query);

  @override
  List<Object?> get props => [query];
}