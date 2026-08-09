import 'package:mobilepos/src/core/databases/app_database.dart';
import 'package:mobilepos/src/features/auth/data/data_sources/impl/auth_local_datasource_impl.dart';
import 'package:mobilepos/src/features/auth/data/data_sources/impl/auth_remote_datasource_impl.dart';
import 'package:mobilepos/src/features/auth/utils/auth_secure_storage.dart';

import 'src/imports/core_imports.dart';
import 'src/imports/packages_imports.dart';
import 'src/app.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final database = AppDatabase();
  final secureStorage = AuthSecureStorage();

  final authLocalDataSource =
  AuthLocalDataSourceImpl(
    database: database,
    secureStorage: secureStorage,
  );
  final authRemoteDataSource = AuthRemoteDataSourceImpl.instance;
  await AppConfig.init(
    localDataSource: authLocalDataSource,
    remoteDataSource: authRemoteDataSource
  );

  runApp(const LocalizationWrapper(child: StateWrapper(child: App())));
  FlutterNativeSplash.remove();
}
