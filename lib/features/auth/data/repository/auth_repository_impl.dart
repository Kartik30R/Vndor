import 'package:vndor/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:vndor/features/auth/domain/entity/user_entity.dart';
import 'package:vndor/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    try {
      return await remoteDataSource.register(email, password);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return remoteDataSource.getCurrentUser();
  }
}
