import 'package:uts_cargo/data/datasource/calculator_remote_data_source.dart';
import 'package:uts_cargo/data/models/calculator_model/calculator_request.dart';
import 'package:uts_cargo/data/models/calculator_model/calculator_response.dart';
import 'package:uts_cargo/domain/repositories/calculator_repository.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  final CalculatorRemoteDataSource remote;

  CalculatorRepositoryImpl(this.remote);

  @override
  Future<CalculatorResponse> createCalculation(
    CalculatorRequest request,
  ) async {
    return await remote.createCalculation(request);
  }

  @override
  Future<List<CalculatorResponse>> getCalculations() async {
    return await remote.getCalculations();
  }
}
