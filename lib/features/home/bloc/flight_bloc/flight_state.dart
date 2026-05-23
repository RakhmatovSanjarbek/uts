part of 'flight_bloc.dart';

abstract class FlightState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoadingMore extends FlightState {
  final FlightSuccess current;
  FlightLoadingMore({required this.current});

  @override
  List<Object?> get props => [current];
}

class FlightSuccess extends FlightState {
  final List<FlightModel> flights;
  final int totalCount;
  final bool hasMore;
  final int currentPage;
  final String currentStatus;

  FlightSuccess({
    required this.flights,
    required this.totalCount,
    required this.hasMore,
    required this.currentPage,
    required this.currentStatus,
  });

  @override
  List<Object?> get props => [flights, totalCount, hasMore, currentPage, currentStatus];
}

class FlightFailure extends FlightState {
  final String error;
  FlightFailure(this.error);

  @override
  List<Object?> get props => [error];
}
