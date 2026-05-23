import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/data/models/flight_model/flight_model.dart';
import 'package:uts_cargo/domain/repositories/flight_repository.dart';

part 'flight_event.dart';
part 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final FlightRepository repository;

  FlightBloc(this.repository) : super(FlightInitial()) {
    on<LoadFlightsEvent>(_onLoad);
    on<LoadMoreFlightsEvent>(_onLoadMore);
    on<FilterFlightsByStatusEvent>(_onFilter);
  }

  Future<void> _onLoad(LoadFlightsEvent event, Emitter emit) async {
    emit(FlightLoading());
    try {
      final res = await repository.getFlights(page: 1);
      emit(FlightSuccess(
        flights: res.flights,
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: 1,
        currentStatus: 'barchasi',
      ));
    } catch (e) {
      emit(FlightFailure(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreFlightsEvent event, Emitter emit) async {
    final current = state;
    if (current is! FlightSuccess || !current.hasMore) return;

    emit(FlightLoadingMore(current: current));
    try {
      final res = await repository.getFlights(
        page: current.currentPage + 1,
        status: current.currentStatus == 'barchasi' ? null : current.currentStatus,
      );
      emit(FlightSuccess(
        flights: [...current.flights, ...res.flights],
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: current.currentPage + 1,
        currentStatus: current.currentStatus,
      ));
    } catch (e) {
      emit(current);
    }
  }

  Future<void> _onFilter(FilterFlightsByStatusEvent event, Emitter emit) async {
    final current = state;
    if (current is FlightSuccess) {
      try {
        final res = await repository.getFlights(
          page: 1,
          status: event.status == 'barchasi' ? null : event.status,
        );
        emit(FlightSuccess(
          flights: res.flights,
          totalCount: res.totalCount,
          hasMore: res.nextPage != null,
          currentPage: 1,
          currentStatus: event.status,
        ));
      } catch (e) {
        emit(current);
      }
    }
  }
}
