import 'package:uts_cargo/data/datasource/flight_remote_data_source.dart';
import 'package:uts_cargo/data/models/flight_model/flight_model.dart';
import 'package:uts_cargo/domain/repositories/flight_repository.dart';

class FlightRepositoryImpl extends FlightRepository {
  final FlightRemoteDataSource remote;

  FlightRepositoryImpl(this.remote);

  @override
  Future<FlightListModel> getFlights({int page = 1, String? status}) async {
    return await remote.getFlights(page: page, status: status);
  }
}
