import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/utils/failure.dart';
import 'package:mobilepos/src/utils/utils.dart';
import '../../domain/models/app_user.dart';

abstract class UsersRepository {
  FutureEither<List<AppUser>> getUsers();
}
