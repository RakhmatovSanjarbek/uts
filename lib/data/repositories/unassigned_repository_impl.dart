import 'package:uts_cargo/data/datasource/unassigned_remote_data_source.dart';
import 'package:uts_cargo/domain/repositories/unassigned_repository.dart';

import '../models/unassigned_model/unassigned_model.dart';

class UnassignedRepositoryImpl extends UnassignedRepository {
  final UnassignedRemoteDataSource remote;

  UnassignedRepositoryImpl(this.remote);

  @override
  Future<UnassignedCargoListModel> getUnassignedCargos({
    int page = 1,
    String? search,
  }) async {
    return await remote.getUnassignedCargos(page: page, search: search);
  }
}