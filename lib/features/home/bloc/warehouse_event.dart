part of 'warehouse_bloc.dart';

abstract class WarehouseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetArrivedGroupsEvent extends WarehouseEvent {}

class UploadCheckEvent extends WarehouseEvent {
  final int groupId;
  final List<String> paths;
  UploadCheckEvent(this.groupId, this.paths);
}

class SetDeliveryEvent extends WarehouseEvent {
  final int groupId;
  final String method;
  final String? address;
  SetDeliveryEvent(this.groupId, this.method, this.address);
}
