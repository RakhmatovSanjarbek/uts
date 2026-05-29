
import 'package:dartz/dartz.dart';
import 'package:uts_cargo/data/models/version_model/version_model.dart';

abstract class VersionRepository {
  Future<Either<String, VersionModel>> getAppVersion();
}