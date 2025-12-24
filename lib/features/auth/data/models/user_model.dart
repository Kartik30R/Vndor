 
import 'package:vndor/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
  });

  factory UserModel.fromFirebase(String uid, String email) {
    return UserModel(uid: uid, email: email);
  }
}
