import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';

import '../../core/constants/constants.dart';

class ProfileRemoteDataSource{
  final ApiClient client;

  ProfileRemoteDataSource(this.client);

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