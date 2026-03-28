part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCalculationsEvent extends CalculatorEvent {}

class CreateCalculationEvent extends CalculatorEvent {
  final CalculatorRequest request;
  CreateCalculationEvent(this.request);

  @override
  List<Object?> get props => [request];
}