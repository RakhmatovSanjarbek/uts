import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/data/models/auth_model/otp_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_in_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_up_model.dart';
import 'package:uts_cargo/domain/repositories/auth_repository.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/auth_model/auth_response.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final res = await repository.signIn(
          SignInModel(phone: event.phone),
        );
        emit(AuthSuccess(res));
      } on DioException catch (e) {
        // 🔥 404 — USER YO‘Q → REGISTER
        if (e.response?.statusCode == 404) {
          emit(AuthNeedRegister(event.phone));
        } else {
          final message =
              e.response?.data["message"]?.toString() ??
                  "Xatolik yuz berdi";
          emit(AuthFailure(message));
        }
      } catch (e) {
        emit(AuthFailure(_mapErrorToMessage(e)));
      }
    });


    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.signUp(
          SignUpModel(
            phone: event.phone,
            firstName: event.firstName,
            lastName: event.lastName,
            jshshir: event.jshshir,
            passportSeries: event.passportSeries,
            birthDate: event.birthDate,
          ),
        );
        emit(AuthSuccess(res));
      } catch (e) {
        emit(AuthFailure(_mapErrorToMessage(e)));
      }
    });

    on<OtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.otp(
          OtpModel(phone: event.phone, code: event.code),
        );
        if (res.token!=null){
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(Constants.token, res.token!);
        }
        emit(AuthSuccess(res));
      } catch (e) {
        emit(AuthFailure(_mapErrorToMessage(e)));
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

      if (e.type == DioExceptionType.connectionTimeout) return "Internet aloqasi juda sekin";
      if (e.type == DioExceptionType.connectionError) return "Internet bilan aloqa yo'q";

      return "Tarmoq xatoligi yuz berdi";
    }
    return e.toString();
  }
}
