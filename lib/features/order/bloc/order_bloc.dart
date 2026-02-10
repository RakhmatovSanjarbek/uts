import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/data/models/order_model/order_model.dart';
import 'package:uts_cargo/domain/repositories/order_repository.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc(this.repository) : super(OrderInitial()) {
    on<GetOrderEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final res = await repository.getOrder();
        emit(OrderSuccess(res));
      } catch (e) {
        emit(OrderFailure(_mapErrorToMessage(e)));
      }
    });
  }

  String _mapErrorToMessage(dynamic e) {
    if (e is DioException) {
      final dynamic data = e.response?.data;

      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            "Serverda xatolik yuz berdi";
      }

      if (e.type == DioExceptionType.connectionTimeout)
        return "Internet aloqasi juda sekin";
      if (e.type == DioExceptionType.connectionError)
        return "Internet bilan aloqa yo'q";

      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}
