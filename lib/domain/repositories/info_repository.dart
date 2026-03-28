import 'package:uts_cargo/data/models/info_model/info_model.dart';

abstract class InfoRepository {
  Future<InfoModel> getInfo();
}