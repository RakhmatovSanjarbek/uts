import 'package:dartz/dartz.dart';
import 'package:uts_cargo/data/models/version_model/version_model.dart';

import '../../domain/repositories/version_repository.dart';
import '../datasource/version_remote_data_source.dart';

class VersionRepositoryImpl implements VersionRepository {
  final VersionRemoteDataSource dataSource;

  VersionRepositoryImpl(this.dataSource);

  @override
  Future<Either<String, VersionModel>> getAppVersion() async {
    try {
      final result = await dataSource.getAppVersion();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}