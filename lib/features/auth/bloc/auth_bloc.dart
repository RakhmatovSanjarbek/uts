import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/service/auth_service.dart';
import 'package:uts_cargo/core/service/fcm_service.dart';
import 'package:uts_cargo/data/models/auth_model/otp_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_in_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_up_model.dart';
import 'package:uts_cargo/domain/repositories/auth_repository.dart';
import '../../../data/models/auth_model/auth_response.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/user_model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<OtpEvent>(_onOtp);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final token = await AuthService.getToken();
    if (token == null) {
      emit(UnauthenticatedState());
      return;
    }
    emit(TokenExistsState(token: token));
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await repository.signIn(SignInModel(phone: event.phone));
      emit(AuthSuccess(res));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(AuthNeedRegister(event.phone));
      } else {
        final message =
            e.response?.data['message']?.toString() ?? 'Xatolik yuz berdi';
        emit(AuthFailure(message));
      }
    } catch (e) {
      emit(AuthFailure(_mapError(e)));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await repository.signUp(event.model);
      emit(AuthSuccess(res));
    } catch (e) {
      emit(AuthFailure(_mapError(e)));
    }
  }

  Future<void> _onOtp(OtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // FCM tokenni olish — OTP yuborishdan oldin
      final fcmToken = await FcmService().getDeviceToken() ?? '';

      final res = await repository.otp(
        OtpModel(
          phone: event.phone,
          code: event.code,
          fcmToken: fcmToken,
        ),
      );

      if (res.token != null) {
        await AuthService.saveToken(res.token!);
        emit(TokenExistsState(token: res.token!));
      } else {
        emit(AuthSuccess(res));
      }
    } catch (e) {
      emit(AuthFailure(_mapError(e)));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await AuthService.clearAuth();
    emit(UnauthenticatedState());
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event,
      Emitter<AuthState> emit,
      ) async {
    final token = await AuthService.getToken();
    if (token == null) {
      emit(UnauthenticatedState());
      return;
    }

    if (event.user.isApproved) {
      emit(AuthenticatedState(token: token, user: event.user));
    } else if (event.user.isPending) {
      emit(PendingState(token: token, user: event.user));
    } else if (event.user.isRejected) {
      emit(RejectedState(token: token, user: event.user));
    } else {
      emit(TokenExistsState(token: token));
    }
  }

  String _mapError(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Serverda xatolik yuz berdi';
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'Internet aloqasi juda sekin';
      }
      if (e.type == DioExceptionType.connectionError) {
        return "Internet bilan aloqa yo'q";
      }
      return 'Tarmoq xatoligi yuz berdi';
    }
    return e.toString();
  }
}