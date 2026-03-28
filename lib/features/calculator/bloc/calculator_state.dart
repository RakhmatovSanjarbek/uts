part of 'calculator_bloc.dart';

abstract class CalculatorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorLoading extends CalculatorState {}

class CalculatorLoaded extends CalculatorState {
  final List<CalculatorResponse> calculations;
  CalculatorLoaded(this.calculations);

  @override
  List<Object?> get props => [calculations];
}

class CalculatorError extends CalculatorState {
  final String message;
  CalculatorError(this.message);

  @override
  List<Object?> get props => [message];
}

class CalculatorCreateSuccess extends CalculatorState {
  final CalculatorResponse response;
  CalculatorCreateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}