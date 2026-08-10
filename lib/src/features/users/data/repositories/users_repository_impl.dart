import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import 'package:mobilepos/src/utils/failure.dart';
import 'package:mobilepos/src/utils/utils.dart';
import '../../domain/models/app_user.dart';
import '../data_sources/remote/users_remote_datasource.dart';
import 'users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<AppUser>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return right(users);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
