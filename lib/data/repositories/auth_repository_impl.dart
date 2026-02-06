import 'package:uts_cargo/data/datasources/auth_remote_data_source.dart';
import 'package:uts_cargo/data/models/auth_model/auth_response.dart';
import 'package:uts_cargo/data/models/auth_model/otp_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_in_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_up_model.dart';
import 'package:uts_cargo/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthResponse> otp(OtpModel model) async {
    return await remote.otp(model);
  }

  @override
  Future<AuthResponse> signIn(SignInModel model) async {
    return await remote.signIn(model);
  }

  @override
  Future<AuthResponse> signUp(SignUpModel model) async {
    return await remote.signUp(model);
  }
}
