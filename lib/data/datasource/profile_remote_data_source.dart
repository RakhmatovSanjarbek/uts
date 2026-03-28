import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';

import '../../core/constants/constants.dart';
import '../models/user_model/user_model.dart';
import '../models/user_model/user_relative_model.dart';

class ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<UserModel> getUser() async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);
    final res = await clientWithToken.get("/api/auth/me/");
    return UserModel.fromJson(res);
  }

  Future<UserModel> updateUser(
    UserModel newData,
    UserModel? currentUser,
  ) async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);
    final Map<String, dynamic> body = {};

    if (newData.firstName.trim() != currentUser?.firstName) {
      body["first_name"] = newData.firstName.trim();
    }
    if (newData.lastName.trim() != currentUser?.lastName) {
      body["last_name"] = newData.lastName.trim();
    }
    String cleanNewTin = newData.jshshir.replaceAll(RegExp(r'\s+'), '');
    if (cleanNewTin != currentUser?.jshshir) {
      body["jshshir"] = cleanNewTin;
    }
    String cleanNewSerial = newData.passportSeries
        .replaceAll(RegExp(r'\s+'), '')
        .toUpperCase();
    if (cleanNewSerial != currentUser?.passportSeries) {
      body["passport_series"] = cleanNewSerial;
    }
    String formattedDate = _formatBirthDate(newData.birthDate);
    if (formattedDate != currentUser?.birthDate) {
      body["birth_date"] = formattedDate;
    }
    if (newData.address.trim() != currentUser?.address) {
      body["address"] = newData.address.trim();
    }
    if (body.isEmpty) return currentUser ?? newData;

    try {
      final res = await clientWithToken.patch("/api/auth/update/", body: body);
      return UserModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  String _formatBirthDate(String value) {
    if (value.contains('-') && value.split('-')[0].length == 4) return value;
    final parts = value.split('/');
    if (parts.length != 3) return value;
    return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }

  Future<void> deleteAccount() async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);

    try {
      await clientWithToken.delete("/api/auth/delete-account/");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 204) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(Constants.token);
        return;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserRelativeModel>> getPassports() async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);
    final res = await clientWithToken.get("/api/auth/relatives/");
    return (res as List).map((e) => UserRelativeModel.fromJson(e)).toList();
  }

  Future<void> addPassport(UserRelativeModel model) async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);
    try {
      final body = {
        "full_name": model.fullName,
        "jshshir": model.jshshir,
        "passport_series": model.passportSeries,
        "birth_date": model.birthDate,
        "phone": model.phone,
      };
      await clientWithToken.post("/api/auth/relatives/", body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePassport(int id) async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);

    try {
      await clientWithToken.delete("/api/auth/relatives/$id/");
      return;
    } catch (e) {
      rethrow;
    }
  }
}
