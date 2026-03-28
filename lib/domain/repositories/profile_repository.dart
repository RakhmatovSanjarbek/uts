import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/data/models/user_model/user_relative_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getUser();

  Future<UserModel> updateUser(UserModel data, UserModel? currentUser);

  Future<void> deleteAccount();

  Future<List<UserRelativeModel>> getPassports();

  Future<void> addPassport(UserRelativeModel model);

  Future<void> deletePassport(int id);
}
