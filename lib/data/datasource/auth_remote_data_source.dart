import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/data/models/auth_model/auth_response.dart';
import 'package:uts_cargo/data/models/auth_model/otp_model.dart';
import 'package:uts_cargo/data/models/auth_model/sign_in_model.dart';

import '../../core/constants/constants.dart';
import '../models/auth_model/sign_up_model.dart';
import '../models/user_model/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSource(this.client);

  Future<AuthResponse> signIn(SignInModel model) async {
    final res = await client.post("/api/auth/signin/", body: model.toJson());
    return AuthResponse.fromJson(res);
  }

  Future<AuthResponse> signUp(SignUpModel model) async {
    final res = await client.post("/api/auth/signup/", body: model.toJson());
    return AuthResponse.fromJson(res);
  }

  Future<AuthResponse> otp(OtpModel model) async {
    final res = await client.post("/api/auth/verify/", body: model.toJson());
    return AuthResponse.fromJson(res);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<UserModel> getUser() async{
    final token = await getToken();
    final client = ApiClient(token: token);
    final res = await client.get("/api/auth/me/");
    return UserModel.fromJson(res);
  }
}
