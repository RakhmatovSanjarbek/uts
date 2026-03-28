import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/info_model/info_model.dart';
import '../../../domain/repositories/info_repository.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  final InfoRepository repository;

  InfoBloc(this.repository) : super(InfoInitial()) {
    on<GetInfoEvent>((event, emit) async {
      emit(InfoLoading());
      try {
        final res = await repository.getInfo();
        emit(InfoSuccess(res));
      } catch (e) {
        emit(InfoFailure(_mapErrorToMessage(e)));
      }
    });
  }

  String _mapErrorToMessage(dynamic e) {
    if (e is DioException) {
      final dynamic data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ?? data['error']?.toString() ?? "Server xatosi";
      }
      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}