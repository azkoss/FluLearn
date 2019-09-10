import 'package:flutter_app/entity/login_entity.dart';
import 'package:flutter_app/entity/user_profile_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "LoginEntity") {
      return LoginEntity.fromJson(json) as T;
    } else if (T.toString() == "UserProfileEntity") {
      return UserProfileEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}