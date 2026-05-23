part of 'flight_bloc.dart';

abstract class FlightEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFlightsEvent extends FlightEvent {}

class LoadMoreFlightsEvent extends FlightEvent {}

class FilterFlightsByStatusEvent extends FlightEvent {
  final String status;
  FilterFlightsByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}
