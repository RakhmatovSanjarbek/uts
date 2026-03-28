import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/calculator_model/calculator_request.dart';
import '../../../data/models/calculator_model/calculator_response.dart';
import '../../../domain/repositories/calculator_repository.dart';

part 'calculator_event.dart';

part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculatorRepository repository;

  CalculatorBloc(this.repository) : super(CalculatorInitial()) {
    on<GetCalculationsEvent>((event, emit) async {
      emit(CalculatorLoading());
      try {
        final result = await repository.getCalculations();
        emit(CalculatorLoaded(result));
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });
    on<CreateCalculationEvent>((event, emit) async {
      emit(CalculatorLoading());
      try {
        final result = await repository.createCalculation(event.request);
        emit(CalculatorCreateSuccess(result));
        add(GetCalculationsEvent());
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });
  }
}
