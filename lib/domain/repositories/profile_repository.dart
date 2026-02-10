import 'package:uts_cargo/data/models/user_model/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getUser();
}
