part of 'unassigned_bloc.dart';

abstract class UnassignedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnassignedInitial extends UnassignedState {}

class UnassignedLoading extends UnassignedState {}

class UnassignedLoadingMore extends UnassignedState {
  final UnassignedSuccess current;
  UnassignedLoadingMore({required this.current});

  @override
  List<Object?> get props => [current];
}

class UnassignedSuccess extends UnassignedState {
  final List<UnassignedCargoModel> items;
  final int totalCount;
  final bool hasMore;
  final int currentPage;
  final String currentSearch;

  UnassignedSuccess({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    required this.currentPage,
    required this.currentSearch,
  });

  @override
  List<Object?> get props => [items, totalCount, hasMore, currentPage, currentSearch];
}

class UnassignedFailure extends UnassignedState {
  final String error;
  UnassignedFailure(this.error);

  @override
  List<Object?> get props => [error];
}