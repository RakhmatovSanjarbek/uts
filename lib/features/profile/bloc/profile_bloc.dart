import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/data/models/user_model/user_relative_model.dart';
import 'package:uts_cargo/domain/repositories/profile_repository.dart';

import '../../../core/service/auth_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(const ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<GetPassportsEvent>(_onGetPassports);
    on<AddPassportEvent>(_onAddPassport);
    on<DeletePassportEvent>(_onDeletePassport);
  }

  UserModel? _getCurrentModel() {
    if (state is ProfileSuccess) return (state as ProfileSuccess).model;
    if (state is ProfileFailure) return (state as ProfileFailure).model;
    return null;
  }

  Future<void> _onGetProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileInitial());
    emit(const ProfileLoading());
    try {
      final res = await repository.getUser();
      emit(ProfileSuccess(res));
    } catch (e) {
      emit(ProfileFailure(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    final currentModel = _getCurrentModel();
    emit(const ProfileLoading());
    try {
      final res = await repository.updateUser(event.data, currentModel);
      emit(ProfileSuccess(res));
    } catch (e) {
      emit(ProfileFailure(_mapErrorToMessage(e), model: currentModel));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccountEvent event,
      Emitter<ProfileState> emit,
      ) async {
    final currentModel = _getCurrentModel();
    emit(const ProfileLoading());
    try {
      await repository.deleteAccount();
      emit(const ProfileDeleted());
    } catch (e) {
      emit(ProfileFailure(_mapErrorToMessage(e), model: currentModel));
    }
  }

  Future<void> _onGetPassports(
      GetPassportsEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());
    try {
      final res = await repository.getPassports();
      emit(PassportsSuccess(res));
    } catch (e) {
      emit(ProfileFailure(_mapErrorToMessage(e), model: _getCurrentModel()));
    }
  }

  Future<void> _onAddPassport(
      AddPassportEvent event,
      Emitter<ProfileState> emit,
      ) async {
    final currentModel = _getCurrentModel();
    try {
      await repository.addPassport(event.model);
      emit(const PassportActionSuccess("Yangi pasport muvaffaqiyatli qo'shildi"));
      add(GetPassportsEvent());
    } catch (e) {
      emit(ProfileFailure(_mapErrorToMessage(e), model: currentModel));
    }
  }

  Future<void> _onDeletePassport(
      DeletePassportEvent event,
      Emitter<ProfileState> emit,
      ) async {
    final currentModel = _getCurrentModel();
    try {
      emit(ProfileLoading());
      await repository.deletePassport(event.id);
      emit(const PassportActionSuccess("Pasport muvaffaqiyatli o'chirildi"));
      await Future.delayed(const Duration(milliseconds: 500));
      add(GetPassportsEvent());
    } catch (e) {
      emit(ProfileFailure(_mapErrorToMessage(e), model: currentModel));
    }
  }

  String _mapErrorToMessage(dynamic e) {
    if (e is DioException) {
      final dynamic data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            "Serverda xatolik yuz berdi";
      }
      if (e.type == DioExceptionType.connectionTimeout) return "Internet aloqasi juda sekin";
      if (e.type == DioExceptionType.connectionError) return "Internet bilan aloqa yo'q";
      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}