import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/data/datasource/order_remote_data_source.dart';
import 'package:uts_cargo/data/models/order_model/order_model.dart';
import 'package:uts_cargo/domain/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc(this.repository) : super(OrderInitial()) {
    on<GetOrderEvent>(_onGetOrders);
    on<LoadMoreOrdersEvent>(_onLoadMore);
    on<SearchOrderEvent>(_onSearch);
    on<FilterOrderByStatusEvent>(_onFilterByStatus);
  }

  Future<void> _onGetOrders(GetOrderEvent event, Emitter emit) async {
    emit(OrderLoading());
    try {
      final res = await repository.getOrders(page: 1);
      emit(OrderSuccess(
        orders: res.orders,
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: 1,
        currentSearch: '',
        currentStatus: 'Barchasi',
      ));
    } catch (e) {
      emit(OrderFailure(_mapError(e)));
    }
  }

  Future<void> _onLoadMore(LoadMoreOrdersEvent event, Emitter emit) async {
    final current = state;
    if (current is! OrderSuccess || !current.hasMore) return;

    emit(OrderLoadingMore(current: current));
    try {
      final res = await repository.getOrders(
        page: current.currentPage + 1,
        search: current.currentSearch.isEmpty ? null : current.currentSearch,
        status: current.currentStatus == 'Barchasi' ? null : current.currentStatus,
      );
      emit(OrderSuccess(
        orders: [...current.orders, ...res.orders],
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: current.currentPage + 1,
        currentSearch: current.currentSearch,
        currentStatus: current.currentStatus,
      ));
    } catch (e) {
      // Xato bo'lsa oldingi holatga qaytamiz
      emit(current);
    }
  }

  Future<void> _onSearch(SearchOrderEvent event, Emitter emit) async {
    final current = state;
    // ✅ Eski ma'lumotlarni saqlab, faqat background da yangilaymiz
    if (current is OrderSuccess) {
      try {
        final res = await repository.getOrders(
          page: 1,
          search: event.query.isEmpty ? null : event.query,
          status: current.currentStatus == 'Barchasi' ? null : current.currentStatus,
        );
        emit(OrderSuccess(
          orders: res.orders,
          totalCount: res.totalCount,
          hasMore: res.nextPage != null,
          currentPage: 1,
          currentSearch: event.query,
          currentStatus: current.currentStatus,
        ));
      } catch (e) {
        // Silent — xato bo'lsa UI o'zgarmaydi
      }
    } else {
      // Birinchi marta yuklanmagan bo'lsa oddiy loading
      emit(OrderLoading());
      try {
        final res = await repository.getOrders(
          page: 1,
          search: event.query.isEmpty ? null : event.query,
        );
        emit(OrderSuccess(
          orders: res.orders,
          totalCount: res.totalCount,
          hasMore: res.nextPage != null,
          currentPage: 1,
          currentSearch: event.query,
          currentStatus: 'Barchasi',
        ));
      } catch (e) {
        emit(OrderFailure(_mapError(e)));
      }
    }
  }

  Future<void> _onFilterByStatus(FilterOrderByStatusEvent event, Emitter emit) async {
    final current = state;
    if (current is OrderSuccess) {
      try {
        final res = await repository.getOrders(
          page: 1,
          search: current.currentSearch.isEmpty ? null : current.currentSearch,
          status: event.status == 'Barchasi' ? null : event.status,
        );
        emit(OrderSuccess(
          orders: res.orders,
          totalCount: res.totalCount,
          hasMore: res.nextPage != null,
          currentPage: 1,
          currentSearch: current.currentSearch,
          currentStatus: event.status,
        ));
      } catch (e) {
        // Silent
      }
    } else {
      emit(OrderLoading());
      try {
        final res = await repository.getOrders(
          page: 1,
          status: event.status == 'Barchasi' ? null : event.status,
        );
        emit(OrderSuccess(
          orders: res.orders,
          totalCount: res.totalCount,
          hasMore: res.nextPage != null,
          currentPage: 1,
          currentSearch: '',
          currentStatus: event.status,
        ));
      } catch (e) {
        emit(OrderFailure(_mapError(e)));
      }
    }
  }

  String _mapError(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout) return "Internet aloqasi juda sekin";
      if (e.type == DioExceptionType.connectionError) return "Internet bilan aloqa yo'q";
      final data = e.response?.data;
      if (data is Map) return data['message']?.toString() ?? data['error']?.toString() ?? "Serverda xatolik";
      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}