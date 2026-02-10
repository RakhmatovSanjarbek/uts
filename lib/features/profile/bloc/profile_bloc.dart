import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/domain/repositories/profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final res = await repository.getUser();
        emit(ProfileSuccess(res));
      } catch (e) {
        emit(ProfileFailure(_mapErrorToMessage(e)));
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
