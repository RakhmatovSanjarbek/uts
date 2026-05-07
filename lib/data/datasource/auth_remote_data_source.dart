import 'package:dio/dio.dart';
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
    // 1. Hamma tekstli ma'lumotlarni Map-ga solamiz
    final Map<String, dynamic> body = {
      "phone": model.phone,
      "first_name": model.firstName,
      "last_name": model.lastName,
      "jshshir": model.jshshir,
      "passport_series": model.passportSeries,
      "birth_date": model.birthDate,
      "address": model.address,
    };

    // 2. Rasmlarni qo'shamiz (Agar null bo'lmasa)
    if (model.passportFront != null) {
      body["passport_front"] = await MultipartFile.fromFile(
        model.passportFront!.path,
        // filename berish ba'zi serverlarda majburiy, busiz rasm bormaydi
        filename: model.passportFront!.path.split('/').last,
      );
    }

    if (model.passportBack != null) {
      body["passport_back"] = await MultipartFile.fromFile(
        model.passportBack!.path,
        filename: model.passportBack!.path.split('/').last,
      );
    }

    // 3. Map-ni FormData-ga o'tkazamiz
    final formData = FormData.fromMap(body);

    // 5. So'rovni yuboramiz
    final res = await client.post(
      "/api/auth/signup/",
      body: formData,
      isMultipart: true,
    );

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
