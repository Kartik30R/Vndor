
import 'package:vndor/features/auth/domain/entity/user_entity.dart';
import 'package:vndor/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.register(email, password);
  }
}
