part of 'order_bloc.dart';

class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}
class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderModel> model;

  OrderSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class OrderFailure extends OrderState {
  final String error;

  OrderFailure(this.error);

  @override
  List<Object?> get props => [error];
}