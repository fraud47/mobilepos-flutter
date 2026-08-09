import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/models/app_user.dart';



final usersProvider =
Provider<List<AppUser>>((ref) {
  return const [

    AppUser(
      id: '1',
      name: 'Cashier Mpiki',
      email: 'sojandem@gmail.com', role: '',
    ),
  ];
});