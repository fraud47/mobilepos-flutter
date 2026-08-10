import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_user.dart';
import '../../data/data_sources/impl/users_remote_datasource_impl.dart';
import '../../data/repositories/users_repository_impl.dart';
import '../../data/repositories/users_repository.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(UsersRemoteDataSourceImpl.instance);
});

final usersProvider = FutureProvider<List<AppUser>>((ref) async {
  final repository = ref.watch(usersRepositoryProvider);
  final result = await repository.getUsers();
  
  return result.fold(
    (failure) => throw failure.message,
    (users) => users,
  );
});