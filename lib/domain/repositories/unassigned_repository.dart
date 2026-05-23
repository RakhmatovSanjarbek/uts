
import '../../data/models/unassigned_model/unassigned_model.dart';

abstract class UnassignedRepository {
  Future<UnassignedCargoListModel> getUnassignedCargos({
    int page = 1,
    String? search,
  });
}