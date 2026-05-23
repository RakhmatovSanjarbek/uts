part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderEvent extends OrderEvent {}

class LoadMoreOrdersEvent extends OrderEvent {}

class SearchOrderEvent extends OrderEvent {
  final String query;
  SearchOrderEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterOrderByStatusEvent extends OrderEvent {
  final String status;
  FilterOrderByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}