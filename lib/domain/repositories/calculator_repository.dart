import 'package:uts_cargo/data/models/calculator_model/calculator_request.dart';
import 'package:uts_cargo/data/models/calculator_model/calculator_response.dart';

abstract class CalculatorRepository {
  Future<List<CalculatorResponse>> getCalculations();

  Future<CalculatorResponse> createCalculation(CalculatorRequest request);
}
