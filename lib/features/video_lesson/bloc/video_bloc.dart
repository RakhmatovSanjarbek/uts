import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/data/models/video_model/video_model.dart';
import 'package:uts_cargo/domain/repositories/video_repository.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository repository;

  VideoBloc(this.repository) : super(VideoInitial()) {
    on<GetVideoEvent>((event, emit) async {
      emit(VideoLoading());
      try {
        final res = await repository.getVideo();
        emit(VideoSuccess(res));
      } catch (e) {
        emit(VideoFailure(_mapErrorToMessage(e)));
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

      if (e.type == DioExceptionType.connectionTimeout) {
        return "Internet aloqasi juda sekin";
      }
      if (e.type == DioExceptionType.connectionError) {
        return "Internet bilan aloqa yo'q";
      }

      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}
