part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoadingMore extends OrderState {
  final OrderSuccess current;
  OrderLoadingMore({required this.current});

  @override
  List<Object?> get props => [current];
}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;
  final int totalCount;
  final bool hasMore;
  final int currentPage;
  final String currentSearch;
  final String currentStatus;

  OrderSuccess({
    required this.orders,
    required this.totalCount,
    required this.hasMore,
    required this.currentPage,
    required this.currentSearch,
    required this.currentStatus,
  });

  @override
  List<Object?> get props => [
    orders,
    totalCount,
    hasMore,
    currentPage,
    currentSearch,
    currentStatus,
  ];
}

class OrderFailure extends OrderState {
  final String error;
  OrderFailure(this.error);

  @override
  List<Object?> get props => [error];
}