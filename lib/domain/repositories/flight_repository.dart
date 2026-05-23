// domain/repositories/flight_repository.dart
import 'package:uts_cargo/data/models/flight_model/flight_model.dart';

abstract class FlightRepository {
  Future<FlightListModel> getFlights({int page = 1, String? status});
}
