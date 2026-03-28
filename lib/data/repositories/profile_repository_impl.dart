import 'package:uts_cargo/data/datasource/profile_remote_data_source.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/data/models/user_model/user_relative_model.dart';
import 'package:uts_cargo/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserModel> getUser() async {
    return await remote.getUser();
  }

  @override
  Future<void> addPassport(UserRelativeModel model) async {
    return await remote.addPassport(model);
  }

  @override
  Future<void> deleteAccount() async {
    return await remote.deleteAccount();
  }

  @override
  Future<List<UserRelativeModel>> getPassports() async {
    return await remote.getPassports();
  }

  @override
  Future<UserModel> updateUser(UserModel data, UserModel? currentUser) async {
    return await remote.updateUser(data, currentUser);
  }

  @override
  Future<void> deletePassport(int id) async {
    return await remote.deletePassport(id);
  }
}
