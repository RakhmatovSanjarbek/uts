import 'package:uts_cargo/data/models/auth_model/auth_response.dart';
import 'package:uts_cargo/data/models/auth_model/otp_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_in_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_up_model.dart';

abstract class AuthRepository{
  Future<AuthResponse> signIn(SignInModel model);
  Future<AuthResponse> signUp(SignUpModel model);
  Future<AuthResponse> otp(OtpModel model);
}