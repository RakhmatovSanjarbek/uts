import '../../domain/repositories/info_repository.dart';
import '../datasource/info_remote_data_source.dart';
import '../models/info_model/info_model.dart';

class InfoRepositoryImpl extends InfoRepository {
  final InfoRemoteDataSource remote;

  InfoRepositoryImpl(this.remote);

  @override
  Future<InfoModel> getInfo() async {
    return await remote.getInfo();
  }
}