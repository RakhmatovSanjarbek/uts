import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/domain/repositories/unassigned_repository.dart';

import '../../../../data/models/unassigned_model/unassigned_model.dart';

part 'unassigned_event.dart';
part 'unassigned_state.dart';

class UnassignedBloc extends Bloc<UnassignedEvent, UnassignedState> {
  final UnassignedRepository repository;

  UnassignedBloc(this.repository) : super(UnassignedInitial()) {
    on<LoadUnassignedEvent>(_onLoad);
    on<LoadMoreUnassignedEvent>(_onLoadMore);
    on<SearchUnassignedEvent>(_onSearch);
  }

  Future<void> _onLoad(LoadUnassignedEvent event, Emitter emit) async {
    emit(UnassignedLoading());
    try {
      final res = await repository.getUnassignedCargos(page: 1);
      emit(UnassignedSuccess(
        items: res.items,
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: 1,
        currentSearch: '',
      ));
    } catch (e) {
      emit(UnassignedFailure(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreUnassignedEvent event, Emitter emit) async {
    final current = state;
    if (current is! UnassignedSuccess || !current.hasMore) return;

    emit(UnassignedLoadingMore(current: current));
    try {
      final res = await repository.getUnassignedCargos(
        page: current.currentPage + 1,
        search: current.currentSearch.isEmpty ? null : current.currentSearch,
      );
      emit(UnassignedSuccess(
        items: [...current.items, ...res.items],
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: current.currentPage + 1,
        currentSearch: current.currentSearch,
      ));
    } catch (e) {
      emit(current);
    }
  }

  Future<void> _onSearch(SearchUnassignedEvent event, Emitter emit) async {
    final current = state;
    // ✅ Search paytida loading ko'rsatmaymiz — mavjud list qoladi
    try {
      final res = await repository.getUnassignedCargos(
        page: 1,
        search: event.query.isEmpty ? null : event.query,
      );
      emit(UnassignedSuccess(
        items: res.items,
        totalCount: res.totalCount,
        hasMore: res.nextPage != null,
        currentPage: 1,
        currentSearch: event.query,
      ));
    } catch (e) {
      if (current is UnassignedSuccess) {
        emit(current); // Silent fail
      } else {
        emit(UnassignedFailure(e.toString()));
      }
    }
  }
}