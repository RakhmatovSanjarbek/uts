import 'package:uts_cargo/data/datasource/profile_remote_data_source.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserModel> getUser() async{
    return await remote.getUser();
  }
}
