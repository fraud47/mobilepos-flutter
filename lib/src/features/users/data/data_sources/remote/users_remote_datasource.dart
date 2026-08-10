import '../../../domain/models/app_user.dart';

abstract class UsersRemoteDataSource {
  Future<List<AppUser>> getUsers();
}
