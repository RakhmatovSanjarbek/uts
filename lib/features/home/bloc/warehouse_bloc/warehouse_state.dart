part of 'warehouse_bloc.dart';

abstract class WarehouseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WarehouseInitial extends WarehouseState {}

class WarehouseLoading extends WarehouseState {}

class WarehouseLoaded extends WarehouseState {
  final List<ArrivedGroupResponse> groups;

  WarehouseLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class WarehouseError extends WarehouseState {
  final String message;

  WarehouseError(this.message);

  @override
  List<Object?> get props => [message];
}
