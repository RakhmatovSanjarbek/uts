
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/warehouse/arrived_group_response.dart';
import '../../../domain/repositories/warehouse_repository.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final WarehouseRepository repository;

  WarehouseBloc(this.repository) : super(WarehouseInitial()) {
    on<GetArrivedGroupsEvent>((event, emit) async {
      emit(WarehouseLoading());
      try {
        final res = await repository.getArrivedGroups();
        emit(WarehouseLoaded(res));
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });
    on<UploadCheckEvent>((event, emit) async {
      emit(WarehouseLoading());
      try {
        await repository.uploadPaymentCheck(event.groupId, event.paths[0]);
        add(GetArrivedGroupsEvent());
      } catch (e) {
        emit(WarehouseError(e.toString()));
      }
    });

    on<SetDeliveryEvent>((event, emit) async {
      emit(WarehouseLoading());
      try {
        await repository.setDelivery(event.groupId, event.method, event.address);
        add(GetArrivedGroupsEvent());
      } catch (e) { emit(WarehouseError(e.toString())); }
    });
  }
}